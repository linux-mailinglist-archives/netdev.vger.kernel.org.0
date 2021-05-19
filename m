Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB42388536
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 05:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352971AbhESD21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 23:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbhESD20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 23:28:26 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A4BC06175F;
        Tue, 18 May 2021 20:27:07 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 9ADFAC024; Wed, 19 May 2021 05:27:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1621394824; bh=5kK5zPmDiySqTPz9AZYojzz9uGThxf9kCqsvsT/oC4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D1mBr0xDl7jD/RRBorrON1MEMqKPP8vNSsyXNZBGe/DoGpNTYaCdtwsJZ1GULq3Zh
         apffmRPx50w52h5K86xV0vLECgb7CYu5UYiQwz3QobxvVw0QvJqyH1ZRVQLCFMueEH
         UXdntQBKijIoDtzmSmYfnN9stBFMCwS/xzUqIGeSCpiHG16ie1Wa2rfGQuquKPWRGh
         aEnmJZiYAXJF3D3BWP/ZpUV28rLB7/C4LDBGsLKuwMsCNXKd11/0WUygOVx5+fO2Yx
         yhE8SzRIaCXd7cTPdiMrat/Kxu2KpyFmkKPP0dfjzralT/GYwLB3R4QChQth18TZ7T
         iwvzHuHfoFxpg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 455BAC01D;
        Wed, 19 May 2021 05:27:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1621394823; bh=5kK5zPmDiySqTPz9AZYojzz9uGThxf9kCqsvsT/oC4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=3Q4goiSD9JSAqfBPh7IBatqZws/+krfBNNyxmNJ3seZ5ABFJ5V6/XY/cm3cE8GcHg
         /8BNnv19hv81JElKsg15wrrURQD4+PjybeI3x3mGcgJdtYKklv3wFUsPk1IR+zjA0i
         J+9aaiUNEIdKddheKsd1hVEvqK2xB98wuKMis1bBuaiDK6vTjx5on6SU8iB3rSp9OX
         EM9ejHssxLu4h8zEMLCtjNRjRUVwhrbgIBlET1CGPKKhNAvqPnIvG2KFrFPgcXWqLP
         ECZG/BM7cg/HzzFvcEe83nB3jjJgwA+dXc6G99g+JpgtkGQ7PleyP6GZ93SsT3jKGQ
         UV2vR5JMZOfOQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 648993a5;
        Wed, 19 May 2021 03:26:57 +0000 (UTC)
Date:   Wed, 19 May 2021 12:26:42 +0900
From:   asmadeus@codewreck.org
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/9p: use DEVICE_ATTR_RO macro
Message-ID: <YKSFchOrlTUxBto1@codewreck.org>
References: <20210519025639.12108-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210519025639.12108-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing wrote on Wed, May 19, 2021 at 10:56:39AM +0800:
> Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Sure, why not.
Will queue to -next tomorrow-ish

-- 
Dominique
