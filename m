Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E0FF10AB
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 08:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbfKFH4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 02:56:17 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39178 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbfKFH4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 02:56:17 -0500
Received: by mail-lj1-f196.google.com with SMTP id p18so1598595ljc.6
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 23:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xweVifWZ/YqguIkP3wRFBeRke8fVrDKetgEyLrXZK4A=;
        b=SRkgLFaa63C9qmcFdcf/s/KAPgAENphVcMUoM+vz9BIEzbf8c06I0Y1Hb5KXR42LXI
         G+i3eaIvU5rZa0kOrwSOnHxSXGm7OyVoMHx/peFrsf/OMV0cjkz5laiG3DlkVHfPCESn
         Pq9m25d73Eymy1sG4V505XAYT460OEuZk3NdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xweVifWZ/YqguIkP3wRFBeRke8fVrDKetgEyLrXZK4A=;
        b=hdDEeB9DI2RGUJL2g9Vic75F2cncPPCNiDKwyCpraqLOeDRJ3aKpyfyXzkzWlTs9OC
         NVRNJ4yVu3q62HP2y6UOosEtsc57g+Pi7DI5xhJoWd1UdfQP5bA2UYsaS5+UeM4uL32g
         z38YcvPVV8wIAq0KzJRdULb9yZ3ipb1w2H3SCO0VeYZ48vwMBoZSdAZWS20sa+2JE0f2
         jMfj4WHsye8K4Xqv8LcQCg3iZsQMI2NtqBzome+DpzXopVfgKs6NwTjCNmlMk+/xdGFj
         wWorc2//wgz+F8YQac2tZwxjhXVCiqZ1QDMRO9csHGWNh7rwMHtsZyfPEAz/5A6PW6+S
         t4ZA==
X-Gm-Message-State: APjAAAU7c85XAqFKzvG639CIHx6/453N6r0wd3h29Vw4PlvqwCnGu+R7
        FMhWWEqp8XU549PzOJ9Mwo159oRr2r6XmQ==
X-Google-Smtp-Source: APXvYqx0UMAxK46d8rifJbbO0Iei8z4btT+kJJezWPrwvpREfmjRSXZQf51n+CDfByMCvypaqmMFbg==
X-Received: by 2002:a05:651c:105:: with SMTP id a5mr819866ljb.45.1573026973653;
        Tue, 05 Nov 2019 23:56:13 -0800 (PST)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id d27sm11001361lfb.3.2019.11.05.23.56.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 23:56:12 -0800 (PST)
Subject: Re: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on
 PPC32
To:     Qiang Zhao <qiang.zhao@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-36-linux@rasmusvillemoes.dk>
 <4e2ac670-2bf4-fb47-2130-c0120bcf0111@c-s.fr>
 <VE1PR04MB6687D4620E32176BDC120DBA8F620@VE1PR04MB6687.eurprd04.prod.outlook.com>
 <24ea27b6-adea-cc74-f480-b68de163f531@rasmusvillemoes.dk>
 <VE1PR04MB67686E14A4E0D33C77B43EA6917E0@VE1PR04MB6768.eurprd04.prod.outlook.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <d8bf1d7f-b4c6-ef92-9fac-a3668ff37d8d@rasmusvillemoes.dk>
Date:   Wed, 6 Nov 2019 08:56:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB67686E14A4E0D33C77B43EA6917E0@VE1PR04MB6768.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11/2019 07.16, Qiang Zhao wrote:

> 
> I tested your v3 patches on ls1043ardb which is arm64 for fsl_ucc_hdlc, it can work,
> Only it will put a compile warning, I also made a patch to fix it.
> I can send a patch to remove PPC32 dependency when I send my patch to support ARM64.
> Or I add my patch in your patchset.

Please send your patch (without whatever Kconfig hunk you needed to add)
with a proper changelog etc. If it looks reasonable (to me, reviewers of
the whole thing obviously also need to agree), I'll include it in my
series and drop adding the PPC32 addition to FSL_UCC_HDLC. Otherwise
I'll keep that and then you can later drop the PPC32 dependency.

Rasmus

