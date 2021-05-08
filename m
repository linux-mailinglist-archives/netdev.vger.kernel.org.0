Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215C4376F91
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 06:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhEHEgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 00:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhEHEgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 00:36:45 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5786C061574;
        Fri,  7 May 2021 21:35:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ge1so6328256pjb.2;
        Fri, 07 May 2021 21:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=mb3BGM16x7Xe0gx2+n/qTDSlXlHCwNft0stvutYSgdM=;
        b=eRqfGvt6oB4OT8ED4CclVaxJ78rEifGaWxb6C08cqU7WghFstXy3lnK6LhlisY4eei
         VYiOnMFNuUxYxexJeq1h0Bo6MS/rYcnouPsBRz4/T6uUpwozW3Xjqzv5nADL/1Zj05NN
         +ePEyUYKdxkc23iBeOZJu3Cfoys0/MvI41kIKp67dRulSofOOPgrJ29djGFRSHwNrGKM
         nry8gDy6/gBGJuirdh5GkukNQn2G0Cq3DByeMgGTWIW+o/MmOGPXT/9vtB8/enmYRPtA
         zUFK6tV1EzwZZ/NsHFXir933xynHvhuXWggdBIUpQBH9nQ5HBXPcbjjcUOSwiUXA7Uwk
         DvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=mb3BGM16x7Xe0gx2+n/qTDSlXlHCwNft0stvutYSgdM=;
        b=gWYMVpaT53oYJHM2Qoty2tuad+6cuDb5CbBWAabSA8njWnfO67PxsPZnpBgwxMTZq3
         ajqYUcOoTU+7E8z9czcywQigoiBv5TDR5373+mtkV9LPBcO4ASYIbj5mLsgJSqKTm5b6
         ImV0RK6gur/qOaDtiB1UdVFBI4dwnDNPu4FvRgR80IfAREQCsbOOef0ErjRQvsH6Cltd
         2/F0sjFJPM+C4t1moEe5+GXYlEY9BPk7Ht5K1c/hz3XTgBvioIuK6wbOJiG2zB7AYdHl
         7jQTKfR49BaOtJ+4t3Wj1s3z90cPDT/trFDeOAMUKlpu/ubXdX7ikDxtyJ/QRpcYRdfi
         fXjw==
X-Gm-Message-State: AOAM530JOyVwVJCFpRAWqGyxP8IAA59gi7ueNAac55U1q6O2bn0y0a2E
        AOX+1bL7I7XnjREh8sFotjE=
X-Google-Smtp-Source: ABdhPJzaDaKcMlevtLCEZf/3+83Z5j2CdSMCOm5/iYsLIv8pDLe85FjMz2DQD8qIta6UJlMDM0rZXw==
X-Received: by 2002:a17:90a:e298:: with SMTP id d24mr14533166pjz.144.1620448543121;
        Fri, 07 May 2021 21:35:43 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id n5sm5915810pfo.40.2021.05.07.21.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 21:35:42 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 28/28] net: phy: add qca8k driver for qca8k switch internal PHY
Date:   Sat,  8 May 2021 12:35:35 +0800
Message-Id: <20210508043535.18520-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508002920.19945-28-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com> <20210508002920.19945-28-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 02:29:18AM +0200, Ansuel Smith wrote:
> Add initial support for qca8k internal PHYs. The internal PHYs requires
> special mmd and debug values to be set based on the switch revision
> passwd using the dev_flags. Supports output of idle, receive and eee_wake
> errors stats.
> Some debug values sets can't be translated as the documentation lacks any
> reference about them.

I think this can be merged into at803x.c, as they have almost the same
registers, and some features such as interrupt handler and cable test
can be reused.

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
