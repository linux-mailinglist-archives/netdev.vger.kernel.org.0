Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F83829E2AB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391202AbgJ2CcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbgJ2CcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:32:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB95FC0613CF;
        Wed, 28 Oct 2020 19:32:17 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z24so1125773pgk.3;
        Wed, 28 Oct 2020 19:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vfXSdidF+OI1hYeq7MULtunlBiX9HjqHRt1cbV+rUcg=;
        b=vgMaRAlT6b4/7Zl7weNe/3/F1Dx8nREOKKD7a6UMz0MXYtOTAHatJtmLsqSusPKpeJ
         lPacrrSGad9XG20tmFcDrN6kpADa3m61ZiRuY2GtitJtlcwLfewiVt+Jj30WRrtaVshg
         TtKwDuaSxZ9skZBllHH/Hub6BK6xblJDDLr2Af2V+jeaFX5r9XxmcBkcVkQqIOrP1neu
         Ay6DkDRbid+8fKjpV+HMVpwDtx1sI1ivj8dzS4uLd5JccFezGZIaBfP7MfHLdq+Cjw8/
         mCQRr/uAEHIDDDY21Bl2RPmx8XJgbVsitAhj4CP1DSABwlss0eZ30yr6jXPCDuVuaaCU
         FohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vfXSdidF+OI1hYeq7MULtunlBiX9HjqHRt1cbV+rUcg=;
        b=hrc6Ow/PW4xEKmWJdVKIGjnWEsPs5+EjNG0uSxijsD2Ud6wuY0hmhrQaVcY/IrAwqP
         qyPBt/iKAUS7WTuG4juhRQRHezXsDC1Du0WSoSBUv6yvsxapDTMCKPdfvLp4jNWk9K/T
         XZ5jO8srqKn9d32Koq8MPsxw85u/kZV0RNjABGbyBe44YkWO59DeKuZelSMVjt854z1K
         9pcB9tO5dxcTCgye6A1SZHX70g4NCCQJIEHd8IQQPKzvQP/fiQxW9VOG6FbYwGvhaODz
         0BLCidq1SNATOhbCALtsinnBQWgCppv+tyraMH2wEM82RkBAQwTdoGovTxNz1Y1tl+yC
         KuQQ==
X-Gm-Message-State: AOAM533skPtq0OCq6TJ5mBZHgUvCJdBL5nHXc6r90pcZAUv3A0QjzcvK
        wyCvF8+O2EBvfgzHoEhyBxplojZJk/U=
X-Google-Smtp-Source: ABdhPJzx6GlTqvxVchTYbwc4eE2LEOug1MDsz/DX0BOhyVZVYNDqxkQ3hIrKG6w9bmxFDoKCEF3v7A==
X-Received: by 2002:a17:90b:14ca:: with SMTP id jz10mr1337421pjb.180.1603938737160;
        Wed, 28 Oct 2020 19:32:17 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x29sm907051pfp.152.2020.10.28.19.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:32:16 -0700 (PDT)
Subject: Re: [PATCH net-next 3/5] net: mscc: ocelot: remove the "new" variable
 in ocelot_port_mdb_add
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c956aa9c-87cd-e1f3-5114-116473145556@gmail.com>
Date:   Wed, 28 Oct 2020 19:32:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029022738.722794-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 7:27 PM, Vladimir Oltean wrote:
> It is Not Needed, a comment will suffice.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
