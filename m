Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C691F0A65
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 00:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbfKEXqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 18:46:54 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46318 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729688AbfKEXqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 18:46:54 -0500
Received: by mail-oi1-f195.google.com with SMTP id n14so3555057oie.13;
        Tue, 05 Nov 2019 15:46:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iUouFbp90DaJNrdZUlRPbAF1tArrEhWp17DotmP+0tk=;
        b=GloMFkSFVv49fXIslmM52FiD0h/B9XkMpjoHj1MXvgheY65bTWwWSk6p/4aK+I9TVe
         1EfViQDuMqXCpnQVMGQMBJFdv0yU0UOi5H5WlgREzNddxnkKwMDNW59Rqd2PmFU8Eeiv
         QIXvJF3+eHdm1AmoY7I5yXW6lWj2t7a4F6OzbyP35B3VQ4MkBNJ/1plVR6NpuY2m1eaB
         ztSd4cen/NHFOjphDxRhXfQiH7pYtCTHYCLqqE9fVy0YM7Ir943PtSUKNIcOpVVp5A8T
         /7CPV5YTXByaku4yaZVAdJRcXF+33VIamlX4OLFzuR9ABxYgxpC4aC9ZpvR1b5PmluyQ
         ZHIQ==
X-Gm-Message-State: APjAAAUVrHE/eVsUUIU6udNo7CsA77HKTu3oWVvrpB/pIm0z34l2O1p4
        EAXBBwB93BhbcX5iJrerNs8Rusqh
X-Google-Smtp-Source: APXvYqx2sB/nZShS59xQ2K7VoozaocRKTiLFPqFuZhBFsy52EfV9aJW59ycbQL6dmg/bn7uuUYnxTQ==
X-Received: by 2002:aca:5a08:: with SMTP id o8mr444760oib.104.1572997611993;
        Tue, 05 Nov 2019 15:46:51 -0800 (PST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id 94sm4841519otg.70.2019.11.05.15.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 15:46:51 -0800 (PST)
Received: by mail-oi1-f179.google.com with SMTP id s71so19279921oih.11;
        Tue, 05 Nov 2019 15:46:51 -0800 (PST)
X-Received: by 2002:aca:4891:: with SMTP id v139mr1318447oia.175.1572997610943;
 Tue, 05 Nov 2019 15:46:50 -0800 (PST)
MIME-Version: 1.0
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk> <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr> <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
 <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk> <CADRPPNQ4dq1pnvNU71vNEgk1V5ovrT9O2=UMJxG45=ZSRdJ4ig@mail.gmail.com>
 <f48df0c7-77f1-268f-8588-7eff5e9fd7c5@rasmusvillemoes.dk>
In-Reply-To: <f48df0c7-77f1-268f-8588-7eff5e9fd7c5@rasmusvillemoes.dk>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Tue, 5 Nov 2019 17:46:39 -0600
X-Gmail-Original-Message-ID: <CADRPPNQ0dR4GkGNmi2dEepJFpULD8DW7_FiYzJZ-er2=UtZ8nA@mail.gmail.com>
Message-ID: <CADRPPNQ0dR4GkGNmi2dEepJFpULD8DW7_FiYzJZ-er2=UtZ8nA@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 4:47 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> On 04/11/2019 21.56, Li Yang wrote:
>
> >> No, this patch cannot be dropped. Please see the kbuild complaints for
> >> v2,23/23 about use of IS_ERR_VALUE on not-sizeof(long) entities. I see
> >> kbuild has complained about the same thing for v3 since apparently the
> >> same thing appears in ucc_slow.c. So I'll fix that.
> >
> > When I made this comment I didn't notice you have removed all the
> > architectural dependencies for CONFIG_QUICC_ENGINE.  If the
> > QUICC_ENGINE is only buidable on powerpc, arm and arm64, this change
> > will not be needed.
> >
> > BTW, I'm not sure if it is a good idea to make it selectable on these
> > unrelavent architectures.  Real architectural dependencies and
> > COMPILE_TEST dependency will be better if we really want to test the
> > buildability on other platforms.
>
> Well, making QUICC_ENGINE depend on PPC32 || ARM would certainly make
> things easier for me. Once you include ARM64 or any other 64 bit
> architecture the buildbot complaints start rolling in from the
> IS_ERR_VALUEs. And ARM64 should be supported as well, so there really
> isn't much difference between dropping all arch restrictions and listing
> the relevant archs in the Kconfig dependencies.

I agree that it will be good to have the driver compile for all
architectures for compile test.  But list all the relevant
architectures and CONFIG_COMPILE_TEST as dependencies will make it not
really selected for these irrelevant architectures in real system.

Regards,
Leo
