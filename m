Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53921398D1
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 00:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbfFGWe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 18:34:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33162 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731164AbfFGWe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 18:34:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so1963575pfq.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 15:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LLvzHistUvG3tFIz6f+WFhmAnRXmHuTQs0YG9JoKNNc=;
        b=b2GA7FeKu504lfwSTtY+Hzk6I9cS1bTN3cNZbLMyc9J57Oz4pC3d9fdBaVtf56cFPB
         lxtzxDAc4P7sct0rcsb/a6zWuy9lEXyOH9YyxkiYB5tZqQ70b2IdhyLpryQ8L/HX4MNu
         L/8LVgACGeYj8XaLgdKBWVxpYDhB4fGgPD3yqe0nV7SC4OfD6w3RFrpnVr0Zvw05Jttw
         JjpshwuDTgqHGV4wlD8ZdvltM8u0bQycC79J/mAd0kLPXbyhkQiXfz08QlWrx0EemjTe
         UOP1gQKwDPvee0Lpv+1BPpbIe7Z9G5tdF/lCeDqDhrK7SETRp42AZ2mywg16UbnrgX+Q
         hUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LLvzHistUvG3tFIz6f+WFhmAnRXmHuTQs0YG9JoKNNc=;
        b=CeEuyLNbKKB4mGkr5JU9lcWWEhd/qV2qhpuTpwdW6mVsuBTUqSZ/bdBarZY5US6sge
         vZHPHgcXQCLxHHmP53dIiHoJLDNdvVGQ6QJXNkcxo6muQqRJfzuoNyEG/KZjR6iz5df5
         K6MIz+bOWXzZNZyL4VLWLIL8zSbXndL2P7tVUgJ//u8aGDfwIwbI5p6jNiFvrKr7RWYa
         ikuU1A69p+WT0MIix1RGjU4GKuLvkqjW5h8mwO5OaBXamEkvfrSLDQCdY96KYZn2iiQF
         QcKreEiD10y3sVzW9Kqfgl0i/p45QnjnFue4V0yPUSEIJ/FLk9l9E4kn5Yrw474zFTvF
         389g==
X-Gm-Message-State: APjAAAVD58E80YIVkS/dcKq6TsziRV2V5f/8uy9Gbo98yzGBt+U8tdgO
        El5alhcXubSMIo5/3G2fm2h3fQ==
X-Google-Smtp-Source: APXvYqyF7j+Lr9Yvi3WvNYmTTdm0OCuF4PPqzAE/3N1Ldnu2toX8LFTn6cpgf4lj/3PyMhG8hs9zsw==
X-Received: by 2002:a65:6210:: with SMTP id d16mr3709222pgv.180.1559946897341;
        Fri, 07 Jun 2019 15:34:57 -0700 (PDT)
Received: from cakuba.netronome.com (wsip-98-171-133-120.sd.sd.cox.net. [98.171.133.120])
        by smtp.gmail.com with ESMTPSA id i22sm3022508pfa.127.2019.06.07.15.34.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 15:34:57 -0700 (PDT)
Date:   Fri, 7 Jun 2019 15:34:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH net-next v2 4/6] taprio: Add support for txtime-assist
 mode.
Message-ID: <20190607153452.53885f87@cakuba.netronome.com>
In-Reply-To: <0ED5E88B-E95A-4899-975D-00912685CEEF@intel.com>
References: <1559843458-12517-1-git-send-email-vedang.patel@intel.com>
        <1559843458-12517-5-git-send-email-vedang.patel@intel.com>
        <20190606162132.0591cc37@cakuba.netronome.com>
        <FF3C8B8E-421E-4C93-8895-C21A38BB55EE@intel.com>
        <20190607150243.369f6e2c@cakuba.netronome.com>
        <0ED5E88B-E95A-4899-975D-00912685CEEF@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 22:27:07 +0000, Patel, Vedang wrote:
> Hi Jacub,=20
>=20
> > On Jun 7, 2019, at 3:02 PM, Jakub Kicinski <jakub.kicinski@netronome.co=
m> wrote:
> >=20
> > On Fri, 7 Jun 2019 20:42:55 +0000, Patel, Vedang wrote: =20
> >>> Thanks for the changes, since you now validate no unknown flags are
> >>> passed, perhaps there is no need to check if flags are =3D=3D ~0?
> >>>=20
> >>> IS_ENABLED() could just do: (flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASS=
IST
> >>> No?
> >>>  =20
> >> This is specifically done so that user does not have to specify the
> >> offload flags when trying to install the another schedule which will
> >> be switched to at a later point of time (i.e. the admin schedule
> >> introduced in Vinicius=E2=80=99 last series). Setting taprio_flags to =
~0
> >> will help us distinguish between the flags parameter not specified
> >> and flags set to 0. =20
> >=20
> > I'm not super clear on this, because of backward compat you have to
> > treat attr not present as unset.  Let's see:
> >=20
> > new qdisc:
> > - flags attr =3D 0 -> txtime not used
> > - flags attr =3D 1 -> txtime used =20
> > -> no flags attr -> txtime not used =20
> > change qdisc:
> > - flags attr =3D old flags attr -> leave unchanged
> > - flags attr !=3D old flags attr -> error
> > - no flags attr -> leave txtime unchanged
> >=20
> > Doesn't that cover the cases?  Were you planning to have no flag attr
> > on change mean disabled rather than no change? =20
>=20
> You covered all the cases above.
>=20
> Thinking a bit more about it, yes you are right. Initiializing flags
> to 0 will work.  I will incorporate this change in the next version.

Cool, thanks! =20

FWIW I think historically TC used to require all parameters specified
and assumed 0 rather than not changed, but I think that was because C
structs were passed as blobs instead of breaking things out per attr.
So today I think its better to make full use of attrs and assume not
present to mean not changed =F0=9F=91=8D
