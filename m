Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5612338D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLQRag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:30:36 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34122 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQRaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:30:35 -0500
Received: by mail-lf1-f65.google.com with SMTP id l18so7558607lfc.1
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 09:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RzyER/QDVJv6afvNMUdBdyKn1bNRVFH/qXMpNB5w+Co=;
        b=Oj9UUdKoB0v3LM5+wH2DWOKLEfpttTrYMty1G0s+aE7bRd7YSlkQwShEBjwVbJe25l
         Sd+cj7rrkNcsf/0kZls2vkLJ/1NDja5N6qOEyz6ukuMeeQbTpIKKhoEjp7iCohdpoZso
         QdMUEFG01a3zTRD8ot0TGJfIUNY2zxEZ4S3TI4AMR0qkKah9tCue7zLEyKoy1uOgrVed
         vIeAOeon8I5k7/1HljniYfRHMTwgoTwJqDqFyZ2dW5Z2EpCbdUA0MiPH3X5TccNZ4P5J
         9ZQaZ8S6VzNcn9cGEmt/Q5akni0czGVWjBu3YTkulOM0kPAPgNH+tIB2pyTQy5j7gSfk
         k20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RzyER/QDVJv6afvNMUdBdyKn1bNRVFH/qXMpNB5w+Co=;
        b=OlEjOCkRk4FcGJnwYivainVU0Y1hjKu8F9dl4lz0SdYjxdl6RkVz4s7iTkqVwhDmid
         RFI0sACU+ZzKAlnZcRlQC8njMbb8T1rIA67JCM7i2qa34S0VX75saQRT6HG0t/oZINzq
         tpYk304asFIcATe4fxmvo/DZPbnefzXU3T1lwD4nkCWtBncZTCFSNW0BSNYLGWvsewJA
         6uLt1sFFmT92JHp0izPTHEbpdCJMbaNifYg9nENAecUeddJp+SK67a4nZwbd3e7F8Dzl
         AVBSKts+Q7TfRLfQIgWAwBg636sb+fAZl9iZDyVKW5ZnFXy8vzyLvTbeJ6VS3NqXogJy
         ybAg==
X-Gm-Message-State: APjAAAV7svGr7Nlf5lwRToMQmt+EKtATA0X21p9gSJXOztIPNoM45RUp
        bcZ3iP2efSHndB9OOnSYPM93DA==
X-Google-Smtp-Source: APXvYqz3uEXKrijfIdS3iiSnsr9vmHOgrVB3EFB4Ov3eW6scOFHqhQOqNUsdFeimE9LZuQOPUf2sVw==
X-Received: by 2002:ac2:5088:: with SMTP id f8mr3436286lfm.163.1576603833604;
        Tue, 17 Dec 2019 09:30:33 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a21sm11071105lfg.44.2019.12.17.09.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 09:30:33 -0800 (PST)
Date:   Tue, 17 Dec 2019 09:30:25 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v3 3/3] openvswitch: New MPLS actions for layer
 2 tunnelling
Message-ID: <20191217093025.71f33a09@cakuba.netronome.com>
In-Reply-To: <20191217171539.GA16538@martin-VirtualBox>
References: <cover.1576488935.git.martin.varghese@nokia.com>
        <9e3b73cd6967927fc6654cbdcd7b9e7431441c3f.1576488935.git.martin.varghese@nokia.com>
        <20191216161355.0d37a897@cakuba.netronome.com>
        <20191217171539.GA16538@martin-VirtualBox>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 22:45:39 +0530, Martin Varghese wrote:
> On Mon, Dec 16, 2019 at 04:13:55PM -0800, Jakub Kicinski wrote:
> > On Mon, 16 Dec 2019 19:33:43 +0530, Martin Varghese wrote: =20
> > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/op=
envswitch.h
> > > index a87b44c..b7221ad 100644
> > > --- a/include/uapi/linux/openvswitch.h
> > > +++ b/include/uapi/linux/openvswitch.h
> > > @@ -673,6 +673,25 @@ struct ovs_action_push_mpls {
> > >  };
> > > =20
> > >  /**
> > > + * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPL=
S action
> > > + * argument.
> > > + * @mpls_lse: MPLS label stack entry to push.
> > > + * @mpls_ethertype: Ethertype to set in the encapsulating ethernet f=
rame.
> > > + * @l2_tun: Flag to specify the place of insertion of MPLS header.
> > > + * When true, the MPLS header will be inserted at the start of the p=
acket.
> > > + * When false, the MPLS header will be inserted at the start of the =
l3 header.
> > > + *
> > > + * The only values @mpls_ethertype should ever be given are %ETH_P_M=
PLS_UC and
> > > + * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are r=
ejected.
> > > + */
> > > +struct ovs_action_ptap_push_mpls {
> > > +	__be32 mpls_lse;
> > > +	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > > +	bool l2_tun; =20
> >=20
> > In file included from <command-line>:32:                               =
        =20
> > ./usr/include/linux/openvswitch.h:674:2: error: unknown type name =E2=
=80=98bool=E2=80=99       =20
> >   674 |  bool l2_tun;                                                  =
        =20
> >       |  ^~~~                                                          =
        =20
> > make[3]: *** [usr/include/linux/openvswitch.hdrtest] Error 1 =20
> >  =20
>=20
> Does that mean bool cannot be used in interface header files ? but what is
> the alternative u8?

I think you have a 16 bit hole there anyway due to the alignment, so
I'd declare the space as __u16 (underscores needed since this is the
user space type), and then validate in the kernel that the higher bits
are unused i.e. return -EINVAL if the field is not 0 or 1, to allow for
a future use of those bits.
