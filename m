Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A148DEEA8D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfKDU4d convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 4 Nov 2019 15:56:33 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39640 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDU4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:56:32 -0500
Received: by mail-ot1-f66.google.com with SMTP id e17so7140973otk.6;
        Mon, 04 Nov 2019 12:56:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/uPNoT5pyyczJJEGNLqWLD6OKr6e8V9JSPptdcpHVcU=;
        b=r5rhj1s0GQUHz2XJnVi03QD+yY01cPK0X9QzCquH+mcGuIT6LRkZ9F0J9DKO3rLy5Q
         A8aNBa54JbFQmJHRAQe/UhlbZfXp2Ne4hJDfMY+Xiwr8L7nD8nm7RuUuaCmOetUQ+Hbz
         M+BuhprdEhA6vBfWsdzdzweHi4gwyb/6nPf842UT31PJvImpN66+VBYZwR1Rej/mlMYV
         e4LdKKLJWGwIOF84w6wjQ78HpiC+IQswsuJmK7+hczjGhoige3ROw9TBFQ72G2ltPBJp
         vAAEKsJuOJebpubvHLy4aBMvz8XwtSWi+z9512QI6I/DXIcln+rWePnwi98aRrrvI4b1
         UlJw==
X-Gm-Message-State: APjAAAWjisxC3I+lQoWNyjwKFZq+FuQ/ry6b7yAUBFQ+a/GFxOgJGFlp
        zD7ZIViUwsVIWxhVmdLAddGhUvr5
X-Google-Smtp-Source: APXvYqzUl0ja+H0Yod0vUDdavrmA8JXURdlQPxvSUM6mU1O2qFFiFeOJDjPcOS4phs4V8BleSABmcg==
X-Received: by 2002:a9d:37a1:: with SMTP id x30mr20836899otb.49.1572900991684;
        Mon, 04 Nov 2019 12:56:31 -0800 (PST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id 63sm5449496oty.58.2019.11.04.12.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 12:56:31 -0800 (PST)
Received: by mail-oi1-f169.google.com with SMTP id l20so3370622oie.10;
        Mon, 04 Nov 2019 12:56:30 -0800 (PST)
X-Received: by 2002:aca:ec89:: with SMTP id k131mr840013oih.154.1572900990777;
 Mon, 04 Nov 2019 12:56:30 -0800 (PST)
MIME-Version: 1.0
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk> <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr> <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
 <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
In-Reply-To: <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Mon, 4 Nov 2019 14:56:19 -0600
X-Gmail-Original-Message-ID: <CADRPPNQ4dq1pnvNU71vNEgk1V5ovrT9O2=UMJxG45=ZSRdJ4ig@mail.gmail.com>
Message-ID: <CADRPPNQ4dq1pnvNU71vNEgk1V5ovrT9O2=UMJxG45=ZSRdJ4ig@mail.gmail.com>
Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on PPC32
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Qiang Zhao <qiang.zhao@nxp.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 2:39 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> On 01/11/2019 23.31, Leo Li wrote:
> >
> >
> >> -----Original Message-----
> >> From: Christophe Leroy <christophe.leroy@c-s.fr>
> >> Sent: Friday, November 1, 2019 11:30 AM
> >> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>; Qiang Zhao
> >> <qiang.zhao@nxp.com>; Leo Li <leoyang.li@nxp.com>
> >> Cc: linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org;
> >> linux-kernel@vger.kernel.org; Scott Wood <oss@buserror.net>;
> >> netdev@vger.kernel.org
> >> Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly
> >> depend on PPC32
> >>
> >>
> >>
> >> Le 01/11/2019 à 13:42, Rasmus Villemoes a écrit :
> >>> Currently, FSL_UCC_HDLC depends on QUICC_ENGINE, which in turn
> >> depends
> >>> on PPC32. As preparation for removing the latter and thus allowing the
> >>> core QE code to be built for other architectures, make FSL_UCC_HDLC
> >>> explicitly depend on PPC32.
> >>
> >> Is that really powerpc specific ? Can't the ARM QE perform HDLC on UCC ?
>
> I think the driver would build on ARM. Whether it works I don't know. I
> know it does not build on 64 bit hosts (see kbuild report for v2,23/23).

The problem for arm64 can be easy to fix.  Actually I don't think it
is neccessarily to be compiled on all architectures except powerpc,
arm and arm64.  I am surprised that you made the core QE code compile
for all architecture(although still have some kbuild warnings)

>
> > No.  Actually the HDLC and TDM are the major reason to integrate a QE on the ARM based Layerscape SoCs.
>
> [citation needed].

I got this message from our marketing team.  Also it is reflected on
marketing materials like
https://www.nxp.com/products/processors-and-microcontrollers/arm-processors/layerscape-communication-process/qoriq-layerscape-1043a-and-1023a-multicore-communications-processors:LS1043A

"The QorIQ LS1043A ... integrated QUICC Engine® for legacy glue-less
HDLC, TDM or Profibus support."

>
> > Since Rasmus doesn't have the hardware to test this feature Qiang Zhao probably can help verify the functionality of TDM and we can drop this patch.
>
> No, this patch cannot be dropped. Please see the kbuild complaints for
> v2,23/23 about use of IS_ERR_VALUE on not-sizeof(long) entities. I see
> kbuild has complained about the same thing for v3 since apparently the
> same thing appears in ucc_slow.c. So I'll fix that.

When I made this comment I didn't notice you have removed all the
architectural dependencies for CONFIG_QUICC_ENGINE.  If the
QUICC_ENGINE is only buidable on powerpc, arm and arm64, this change
will not be needed.

BTW, I'm not sure if it is a good idea to make it selectable on these
unrelavent architectures.  Real architectural dependencies and
COMPILE_TEST dependency will be better if we really want to test the
buildability on other platforms.

Regards,
Leo
