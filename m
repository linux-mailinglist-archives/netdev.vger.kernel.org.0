Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EB43D9490
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhG1RvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:51:00 -0400
Received: from mout.gmx.net ([212.227.15.19]:55433 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1Ru7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 13:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627494638;
        bh=HdN6h2fW3WfZHWgGPBI7mjVQZDP7OyMfQXIZoK6GEzw=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=XV2dRQupPsQVTtuRAZ2PXGCe/kQAEHyNb3HeiKf9hEUEYz69RI+xrX9fxTsh3nNZl
         kscnRJxj3LF3BEOQFZPstdCpOvecdhu2/FtHUYvfpj++GSMdWA2iO8UhffPlAe7PrV
         7G6eXxWJhaDS6MVR4lmXyMi577TmpFYh/I5zTIg8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([79.150.72.99]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MQe9s-1mWVUO09g6-00NmVN; Wed, 28
 Jul 2021 19:50:38 +0200
Date:   Wed, 28 Jul 2021 19:50:34 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] rtw88: Remove unnecessary check code
Message-ID: <20210728175034.GB4275@titan>
References: <20210718084202.5118-1-len.baker@gmx.com>
 <87eebkgt8t.fsf@codeaurora.org>
 <CA+ASDXNm_aKAJcJVCx45VqAXTgXjfOju7xZPa_3MAvBzn2r7_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXNm_aKAJcJVCx45VqAXTgXjfOju7xZPa_3MAvBzn2r7_w@mail.gmail.com>
X-Provags-ID: V03:K1:m3es4IjJjHnlwV3k/7t9iM/XxBCGcLyPyBg3DW8V1vxM6xLECSG
 Sta/V5gh2x8sAw8POckKtqcS31swsOeEYn0I5Izx/CXKxHZMEwloOwoGg0AExqwMyAUpkxE
 sLMxLXHuN0CE1jJdHmuBShyUYgMRQt5tQe8fFPERel1qZCYsSqmi8JklKSeB+iU5d/bkahS
 b6ZUxq9o/Yr9AgzdHWPTg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZrGT3jKiEMg=:uo2hzSTNyBJuQdhBUgGHaI
 Fj45LhRuME4XfYeb8eWC2lRo1mHeX1OmwFaPAhh2bjWCnAY7vnlm8ySen/lMFWc0jVTrAzvPn
 YE/Ku7u4xMusDk3ctkhUwp3Csv5XZunU3jaK9cPwbWBWUznE5LbOV9lex2xHWdRjdFMIqdXJn
 jbvsVkaDKrqdLtT8Fq8EWcWHaFJpDqI0ddm6hqnDWIYsh0umV4PBQJxVv4/wqLCuuIfE8JROA
 bOCgJ2T7v36ODqNZw8TTGIfg2/ImrW1YwrgRAQPKdJ3zWb/tM+aTKlQIlDZO6p7Owd/LVVkaY
 RuBrx4ot5U9ejrmNW2Mt4E5QB8Jb/xVnmPh8+U5LAL4jk9ccBVd739aJfsrcLjuttgrp/p3Mq
 JfiQfxyogLievHRWe7LqlYF1aIfR+EeLdiw0IaOyhgjkfBIQin1STRcemixOOGNxhZbGMSn0W
 SVQiwTgACYZC/nBcHXUTapZHhDKtsxzef2GCyBOshAVTyuVBMENfnvVmne5GkvM7mKWVOlW6G
 dh3P28/WVVAQx4ZMitlar7dYIoH+kWTxy6bNh5jKLU0PMHYo5nQqG8Ip6NQm09AUoKPyGFd9v
 hjN8dcnmqvstU1ZRhIyhCQbtqNoHbivMTp+ZgzA+DUwq8myb48QebaA49V2m4NfqUsY/dShWf
 +EeoOKHS1QBe11/lIIx6VfK6iIn9gsHznbBN3JAabrHgwdwi39Hd5n+L5PchMJD7jEu7eujHU
 Wkqt02ujuX0dyNUY2pGagcnEM/lbC2yhRcCqUxespSKDlruz6G1ogvq2w0ADGGVfiDULIyAnd
 kGpYJhJVLL6pUEg3vuWl46i29FvMVmtBQ/00T8zNsmO1RF2KJZrKJZfx9s2juFmvciNTWawxp
 Z1AlEvl2CxittZr3Ggku/Ft5iTl0ke+niY3T7jwWIf93lYzd3zOS/2xq2fH3Grj5+0Wchc1H1
 p8ElWAJRFC8T1SmjMaOnmjQbUeagVkCTGgd1yt69wMYmaPikdGYuAocIl70wqnEedPwoAP2cS
 8YOYei53Yq5Iwzx0NPnL0P3MAPausYAXMKMT+NLprltW76ZbDRhs12lfjw+i/GN1nydrzzBSz
 75F655Eo78zB3dQLVmtqWb4tK1Euq+vTvgt
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 11:16:11AM -0700, Brian Norris wrote:
> On Mon, Jul 26, 2021 at 11:34 PM Kalle Valo <kvalo@codeaurora.org> wrote=
:
> >
> > Len Baker <len.baker@gmx.com> writes:
> >
> > > The rtw_pci_init_rx_ring function is only ever called with a fixed
> > > constant or RTK_MAX_RX_DESC_NUM for the "len" argument. Since this
> > > constant is defined as 512, the "if (len > TRX_BD_IDX_MASK)" check
> > > can never happen (TRX_BD_IDX_MASK is defined as GENMASK(11, 0) or in
> > > other words as 4095).
> > >
> > > So, remove this check.
> > >
> > > Signed-off-by: Len Baker <len.baker@gmx.com>
> >
> > Are everyone ok with this version?
>
> I suppose? I'm not really sure where the line should be drawn on
> excessive bounds checking, false warnings from otherwise quite useful
> static analysis tools, etc., but I suppose it doesn't make much sense
> to add additional excess bounds checks just to quiet Coverity.
>
> It might be nice to include the true motivation in the patch
> description though, which is: "this also quiets a false warning from
> Coverity".

Ok, I will send a new version with the commit changelog updated.

>
> Anyway, feel free to pick one of these:
>
> Shrug-by: Brian Norris <briannorris@chromium.org>
>
> or
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks,
Len
