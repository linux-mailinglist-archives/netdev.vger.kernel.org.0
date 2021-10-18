Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD2E432398
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhJRQSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhJRQSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:18:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446A6C06161C;
        Mon, 18 Oct 2021 09:16:23 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t7so2292808pgl.9;
        Mon, 18 Oct 2021 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:subject:from:to:cc:date
         :message-id:in-reply-to;
        bh=SwEuwCnXiV80SDJdClsOIhkNBmpbMyPtKGwWzGdE5yc=;
        b=oB6C5Ty03ZxOBOZsbmna53g8YKpZvIPAa/MJ53ylUc8+mVWu2cMEgAQDvewuV/mQmW
         d1aam6+5Lqlose6GRA7YO21xvzukxCTW9Dd9VYkWB1R1QjynOa2ISuYeuGy/7UD6X+Si
         +t0XtPQZbmKE/gymbAIETgIvH+bcOweq/sd/4YieFdCvGcQ27gUiG0Jw0XmI7TB28Fqk
         PP0tiPnwVCjIHGyn2KAXhbklR3kkek1j3fHCByYeCd9D6AFBV+pP9wRhmFb4lPZMFbGg
         q6DdWCJXoF3hlDs9RyHn5ZKy/sy64xzSC1G6h2WpsbuNZ1H6f8XgicG1GOBhQIhk2zY7
         /hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:subject
         :from:to:cc:date:message-id:in-reply-to;
        bh=SwEuwCnXiV80SDJdClsOIhkNBmpbMyPtKGwWzGdE5yc=;
        b=ufMDIzAE42i/k+rIGPkSI5OANwSUONJT6d3WXCt+JdIfDzPRvAvjzJtVi5b+NXHvbr
         AJt7VW8e7tuyt0osPwYmFkS0JKGE1awyx5SjLbTvl5vLiaq6wk2SeSSTETYsQiHrnzcm
         x8NeQf8g7PK6BM3FI+CCYsImsePiO3NyXHHQBP6q43cDs3H7yUrjd3TtWrEC18fWw042
         J3rGOBFpStahcVtccvOMpfJY0ux5WeWbj/4tzjqoayl2eiD1GLtJqWmvvReSbhm4VGgR
         Io+pTdrc6vjl4X2sPlt1i0iJX3RCUvW63wMsj5o1n7UwpA2A/PpeBx6LGnKWg4chdAfe
         6UUw==
X-Gm-Message-State: AOAM533TzvfLFc5Gd+gPaIkaHNOMNCoOASde6/Ag7yV9BIj4Ci9UzvVE
        LP+tA9UAbyPQQMVMMAGyGD4=
X-Google-Smtp-Source: ABdhPJzmiqjJ4gQv1OofM3fUMnZH1cZxOPi++IeGD51mIIqGPptPWRApZZerHodnI84/UmbpxxG6pQ==
X-Received: by 2002:a62:7b87:0:b0:44d:3e28:a2ac with SMTP id w129-20020a627b87000000b0044d3e28a2acmr29942629pfc.67.1634573782720;
        Mon, 18 Oct 2021 09:16:22 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id t14sm19592807pjl.10.2021.10.18.09.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 09:16:22 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: [RFC PATCH 01/17] net: ipa: Correct ipa_status_opcode
 enumeration
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Cc:     "Vladimir Lypak" <vladimir.lypak@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Date:   Mon, 18 Oct 2021 21:42:04 +0530
Message-Id: <CF2NYEUKQORV.3GXBPSZ0DT1BM@skynet-linux>
In-Reply-To: <132dbed4-0dc9-a198-218f-90d44deb5d03@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 3:58 AM IST, Alex Elder wrote:
> On 9/19/21 10:07 PM, Sireesh Kodali wrote:
> > From: Vladimir Lypak <vladimir.lypak@gmail.com>
> >=20
> > The values in the enumaration were defined as bitmasks (base 2 exponent=
s of
> > actual opcodes). Meanwhile, it's used not as bitmask
> > ipa_endpoint_status_skip and ipa_status_formet_packet functions (compar=
ed
> > directly with opcode from status packet). This commit converts these va=
lues
> > to actual hardware constansts.
> >=20
> > Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >   drivers/net/ipa/ipa_endpoint.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpo=
int.c
> > index 5528d97110d5..29227de6661f 100644
> > --- a/drivers/net/ipa/ipa_endpoint.c
> > +++ b/drivers/net/ipa/ipa_endpoint.c
> > @@ -41,10 +41,10 @@
> >  =20
> >   /** enum ipa_status_opcode - status element opcode hardware values */
> >   enum ipa_status_opcode {
> > -	IPA_STATUS_OPCODE_PACKET		=3D 0x01,
> > -	IPA_STATUS_OPCODE_DROPPED_PACKET	=3D 0x04,
> > -	IPA_STATUS_OPCODE_SUSPENDED_PACKET	=3D 0x08,
> > -	IPA_STATUS_OPCODE_PACKET_2ND_PASS	=3D 0x40,
> > +	IPA_STATUS_OPCODE_PACKET		=3D 0,
> > +	IPA_STATUS_OPCODE_DROPPED_PACKET	=3D 2,
> > +	IPA_STATUS_OPCODE_SUSPENDED_PACKET	=3D 3,
> > +	IPA_STATUS_OPCODE_PACKET_2ND_PASS	=3D 6,
>
> I haven't looked at how these symbols are used (whether you
> changed it at all), but I'm pretty sure this is wrong.
>
> The downstream tends to define "soft" symbols that must
> be mapped to their hardware equivalent values. So for
> example you might find a function ipa_pkt_status_parse()
> that translates between the hardware status structure
> and the abstracted "soft" status structure. In that
> function you see, for example, that hardware status
> opcode 0x1 is translated to IPAHAL_PKT_STATUS_OPCODE_PACKET,
> which downstream is defined to have value 0.
>
> In many places the upstream code eliminates that layer
> of indirection where possible. So enumerated constants
> are assigned specific values that match what the hardware
> uses.
>

Looking at these again, I realised this patch is indeed wrong...
The status values are different on v2 and v3+. I guess the correct
approach here would be to use an inline function and pick the correct
status opcode, like how its handled for register defintions.

Regards,
Sireesh

> -Alex
>
> >   };
> >  =20
> >   /** enum ipa_status_exception - status element exception type */
> >=20

