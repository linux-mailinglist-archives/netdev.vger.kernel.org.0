Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852E0100D80
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKRVRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfKRVRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:17:16 -0500
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3049022310
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574111835;
        bh=CmSjnq76UAKUNwTe9LxflmYflKUWJHoV8fX7THvkuLM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Pa7z4BFvrfa/1ll2+IjToHkT8qmbSUAWtegO82Um9Aj6SGi8qk2r0U/n0aQ34f1WY
         rVQzP2YpCMlxotUX1xMfX+tDBxw77uxLmqh6Ub/fXhV8aYguuxZTrVp2A6FqBGUlGZ
         o5dOLAHiS1sa/V1IPryXOlgRd7AcurWxPZ/JNTU8=
Received: by mail-qk1-f170.google.com with SMTP id i3so3853898qkk.9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 13:17:15 -0800 (PST)
X-Gm-Message-State: APjAAAXmdthcxj5GuIc1wCiVUI2NNLLfBQtgz/Je2S8XeiSa41G7gkrJ
        +J8uTdbMfOPuYyk00x9MAUVeRSoRZ+MjJi/gqHE=
X-Google-Smtp-Source: APXvYqzRLDuCv8Rioosudo2jGrhBx8enm2SxenaInuv3VtpArx5+8qAfcMUOcXPpFNRkquNvdD8FM8wz3RJFY49aeeo=
X-Received: by 2002:a37:494d:: with SMTP id w74mr13829097qka.224.1574111834302;
 Mon, 18 Nov 2019 13:17:14 -0800 (PST)
MIME-Version: 1.0
References: <3de90521-8324-087f-f3d1-f616fda021b4@gmail.com> <e1e4ff02b82a4c278364be1924cf31ac@realtek.com>
In-Reply-To: <e1e4ff02b82a4c278364be1924cf31ac@realtek.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 18 Nov 2019 16:17:02 -0500
X-Gmail-Original-Message-ID: <CA+5PVA6OiGmUSZVA_JCRqS9P2q42u5OAuNTLvpgrFoBMPbgCCA@mail.gmail.com>
Message-ID: <CA+5PVA6OiGmUSZVA_JCRqS9P2q42u5OAuNTLvpgrFoBMPbgCCA@mail.gmail.com>
Subject: Re: [PATCH] rtl_nic: add firmware rtl8168fp-3
To:     Hau <hau@realtek.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 1:44 PM Hau <hau@realtek.com> wrote:
>
> >
> > This adds firmware rtl8168fp-3 for Realtek's RTL8168fp/RTL8117.
> >
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>
> Signed-off-by: Chunhao Lin <hau@realtek.com>

Applied and pushed out.  Thanks.

josh

>
> > ---
> > Firmware file was provided by Realtek and they asked me to submit it.
> > Hau, could you please add your Signed-off-by?
> > The related extension to r8169 driver will be submitted in the next days.
> > ---
> >  WHENCE                 |   3 +++
> >  rtl_nic/rtl8168fp-3.fw | Bin 0 -> 336 bytes
> >  2 files changed, 3 insertions(+)
> >  create mode 100644 rtl_nic/rtl8168fp-3.fw
> >
> > diff --git a/WHENCE b/WHENCE
> > index 717c8c9..81ee965 100644
> > --- a/WHENCE
> > +++ b/WHENCE
> > @@ -2957,6 +2957,9 @@ Version: 0.0.2
> >  File: rtl_nic/rtl8168h-2.fw
> >  Version: 0.0.2
> >
> > +File: rtl_nic/rtl8168fp-3.fw
> > +Version: 0.0.1
> > +
> >  File: rtl_nic/rtl8107e-1.fw
> >  Version: 0.0.2
> >
> > diff --git a/rtl_nic/rtl8168fp-3.fw b/rtl_nic/rtl8168fp-3.fw new file mode
> > 100644 index
> > 0000000000000000000000000000000000000000..cc703844615bdde7a03e7238
> > d827b0bb949bf3ca
> > GIT binary patch
> > literal 336
> > zcmW-
> > c!AiqW5JktTAta%d5<*Ff1}P#%)AwQxX%z`7Mf{1VwW1(eN^mLn2mA|{uH3m1
> > zb>Vlsg)99B@!Em&INUeGFd`z;@;cLLb}`x9Dpagu9ckUwX;=68$vPoBq?E~NIl3%H
> > zx98*HZah6G5~cg9mt^tT)lH<5fl3EzTOJ<U?3Ts<XHF#lsI5SxL2Tj>k5tJLsS}?B
> > zm=`f37QlYn2pm&E%`Ct-76N0VVH||UL(5cA`Q+?t9nT#fZ_NNd!v=nvAu8`J$jdT9
> > zH)6iZyp8+j8uNAL9eleRoQ*lFxHF;m=qWv;59qt}J$g>xrytUX^dtH)X1Bn?Q^$ty
> > OI{0!uShL$C7uFv|s8|62
> >
> > literal 0
> > HcmV?d00001
> >
> > --
> > 2.24.0
> >
> >
> > ------Please consider the environment before printing this e-mail.
