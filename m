Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9813772C4
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhEHPt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhEHPt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:49:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262AC061574;
        Sat,  8 May 2021 08:48:24 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so7231776pjb.3;
        Sat, 08 May 2021 08:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FyEdw5ElY1k7a7pJcsygfU2Y/gFiYaGxdCJTofLtOYY=;
        b=rZrv94FytVYzbW72OWjv3aivuKfJsp86KN8CEyW5RkB2Fc1+P7VBK/+Ob474toZECW
         1k8OWPRGAvENz5UGeR0mqYNe3eBoIbhnaY/HTrPJxKUDD40CdkNkLsaImiBPTBSsQhRI
         BN2AbfptQq53+Lt1PBwu6wKgSsTYeV89dq8I7xJyUHIlfs5nbUOry4wE1dYwtQFtwbiK
         d6G4m1ZsNcrkqb+y/gaI73IHgOdUYZgjxm2choxsPFVs2OkE76KU/jp12uAd1MmRAnsR
         tMlkwAYhnJiHAW/aQSvvVTKOcihIUGlpObUiflixxek8sSJk25pwWUzPBoOKueyvfPPS
         fFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FyEdw5ElY1k7a7pJcsygfU2Y/gFiYaGxdCJTofLtOYY=;
        b=meF53OsYOd6gqbkLoNqhIu8/Sd1aO4d1OS9AiPvn1REcRiUOCKGh7QFXhuVcEluGH1
         NzDYjqj9eBzjXq5eutDKeaTx5Of2Z8Fnb/JYenLnCh5Kh+aIAQNikBVSRWvrVP+p6h0h
         owE7djiMfLKzLSdPmjAl/kq2zRzn0vuaq+tM47BN581xq+44q8ELgGCJz4Kq/QMMRQ1K
         QydpQe063UDYKfDT+oCYm5aIs6oECnmIhY/79RsyLb7JjTaWbKMDeKP4cRloReCtBh0e
         PzxyzhT9uTiPdFFfIFB8vHMARw2hpUPSPF1oXeJ17JMB1dHu4PXocAO/rErMmM4Z9/TO
         +SBg==
X-Gm-Message-State: AOAM532d4cwE5lmSGb8W+9tfhvjMs4zhc+poTtbLh3MM0eQ9eF4Dxlgj
        TTj0BHTQ3lUjFYn21m2Ms6tRf8gr3OQ=
X-Google-Smtp-Source: ABdhPJyxglAP7bvQlQh+DYXyr2iE0XuEyY+CdpkWnZrvIGH+ed9cp+3LMjaFKaRsMn5vJVD1Ic/y7Q==
X-Received: by 2002:a17:902:7c8a:b029:e6:f010:a4f4 with SMTP id y10-20020a1709027c8ab02900e6f010a4f4mr15748380pll.17.1620488903987;
        Sat, 08 May 2021 08:48:23 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d20sm7056376pfn.166.2021.05.08.08.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:48:23 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 17/28] net: dsa: qca8k: add support for
 switch rev
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-17-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84f948fd-b6e9-7e79-2b97-6ceddd722d7b@gmail.com>
Date:   Sat, 8 May 2021 08:48:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-17-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> qca8k internal phy driver require some special debug value to be set
> based on the switch revision. Rework the switch id read function to
> also read the chip revision.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
