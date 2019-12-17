Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4D6121F51
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfLQAOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:14:04 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39800 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQAOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:14:04 -0500
Received: by mail-lj1-f195.google.com with SMTP id e10so8812323ljj.6
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 16:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dgYUmM0K4L1moLYSCIb90cgtR++pCuZEaORXa9TgVT0=;
        b=q2KqFX8kR5/3zEgkITXp/9eAPEVNFei5nH9B0rPY3U0wrEZlW7bev/NzPJ0HPHuCtO
         iPrhyWDL3PiT5htW5s1zL8tfBebegbfqlqxs7QYspPsk+yXk69okXAqSlVV7ZBhB4AtE
         dyqOyuP5VR9TY4853TGOOpThWVSlmqmi5L6U3Z5caQN6JJodENAJObw6sV69Y4BGwvpn
         ot8F2zXpAO3SPPisWhyvYnJOi4nD5T2I6HwU2qXfhI4nenXR1E3TC8MPWpZ3kRnUybCC
         no/kXsl6GFOgTDRqUptDphBoA5oAYICSU2aVftl1NIxZx2CYpL/4fxzUap7qMYSeRs/r
         BR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dgYUmM0K4L1moLYSCIb90cgtR++pCuZEaORXa9TgVT0=;
        b=SHdDPRQDILGYNISAXsufs8lzGHeBJjMChkNHuL3ZCU+5vtxxfxovdrI5Fakoz5e9dq
         DL67kM3K5bz34XxJyn7kssTGyf2WhTbfdbSayKM/ntqYOpz2+nfgl1yboygqwvIgYOyS
         AWdTbSQMLJFnpHxDgwn4PRM1qXTtcnmoDPumXxeqMPsEcPith1gBhu1NPPCSkOi+DoNf
         AQhYT4ZQxJEPRcvisjd0ns+t9rs964xtghoxVptokS8yI97RHYFXIsIv2h2VSHkzvjgD
         vSkpKqJykiZvnBJSrd/f2URSmLwSXVpeZqUlL1QekN8lbvPpXjmPZkWR0QNa/ECIuHfo
         cjXw==
X-Gm-Message-State: APjAAAWxwqm5HnfF9ryQCM8HoOMDZJhRrFVq9rnjzJaIJiT0AvUs0zXZ
        Wd/UpR4XaIdwQOelTsRRwJ/vbQ==
X-Google-Smtp-Source: APXvYqzd8QNWBeyL5+vB0M0D6fgUZZ2TtcQy9tvY2tJuxJJov2SD5/XsfQqUgEIwSQdhHkVLPOt1LQ==
X-Received: by 2002:a2e:9e03:: with SMTP id e3mr1263263ljk.186.1576541642254;
        Mon, 16 Dec 2019 16:14:02 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z9sm11292570ljm.40.2019.12.16.16.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 16:14:02 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:13:55 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v3 3/3] openvswitch: New MPLS actions for layer
 2 tunnelling
Message-ID: <20191216161355.0d37a897@cakuba.netronome.com>
In-Reply-To: <9e3b73cd6967927fc6654cbdcd7b9e7431441c3f.1576488935.git.martin.varghese@nokia.com>
References: <cover.1576488935.git.martin.varghese@nokia.com>
        <9e3b73cd6967927fc6654cbdcd7b9e7431441c3f.1576488935.git.martin.varghese@nokia.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 19:33:43 +0530, Martin Varghese wrote:
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvs=
witch.h
> index a87b44c..b7221ad 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -673,6 +673,25 @@ struct ovs_action_push_mpls {
>  };
> =20
>  /**
> + * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPLS ac=
tion
> + * argument.
> + * @mpls_lse: MPLS label stack entry to push.
> + * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
> + * @l2_tun: Flag to specify the place of insertion of MPLS header.
> + * When true, the MPLS header will be inserted at the start of the packe=
t.
> + * When false, the MPLS header will be inserted at the start of the l3 h=
eader.
> + *
> + * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_=
UC and
> + * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejec=
ted.
> + */
> +struct ovs_action_ptap_push_mpls {
> +	__be32 mpls_lse;
> +	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> +	bool l2_tun;

In file included from <command-line>:32:                                   =
    =20
./usr/include/linux/openvswitch.h:674:2: error: unknown type name =E2=80=98=
bool=E2=80=99       =20
  674 |  bool l2_tun;                                                      =
    =20
      |  ^~~~                                                              =
    =20
make[3]: *** [usr/include/linux/openvswitch.hdrtest] Error 1 =20

> +};
> +
> +

Why the double new line? Please use checkpatch --strict.
