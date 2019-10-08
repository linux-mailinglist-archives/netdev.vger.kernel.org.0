Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3FD0105
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbfJHTNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:13:33 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38191 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfJHTNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:13:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id u186so17888801qkc.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=t6oyuMaPUmyNVT7v4DLW2+8p5dzVhG7Z1YsODEnTYJc=;
        b=Ahx2xM/Ka2OvT+Z8TrK2ZtgnFwLp3ML09vr39yCsPXewB9cSBKn8r2C75aPi6CSdgT
         hID2DzhcFNBPTAB1iBCdlYNlRTHMI8M7wA5syNbttRyBzqSNFtGU45Ts1Ugcs39sEsPF
         xjUjS1QCBvajmZQ7S1vTHTHW8vhCM7R8i33/13MD3D5yXy/kfTyMfNVmq88CPZf9qvz/
         x59LYN8gSkqOgtNPRZNlL8w4woGhJufgQvv3icIe5rxzORHPXHtFAPLAiIBMCNnQu4bc
         zzunS0e+Wf5JkmeVa33HDlgw6/QORMS3ARhuwbWgytoODOGAw3z0IIeAynZuGiHWddPB
         EO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=t6oyuMaPUmyNVT7v4DLW2+8p5dzVhG7Z1YsODEnTYJc=;
        b=HAbtKt4tQhLVc4hpRRJAJInIr1UprVh9G2/ir9FRPrSTBJwkMRP+QABE9NhFX904mb
         BZ76jRo2PznOyNZyJfrnBhBznRn0ZZQVyVvWvw6Di0H+F5Mum7Ti9g+VybDWs1vyOH7o
         iWq1xSLg4tHFfKJivGHK8YlwlxcytBMKvulxrRQUPBH3c47r9oaJFYhvdrV4Yh+I9MHV
         CtwzNlaBCpBCySEowYwNfoyfbcGRUo4muV1wQrChx+tCeXqhkwJGBlrkpoJxHxwZBVgY
         en3zwUGb90HtJOAPHRd3G41Kx5aJAMGw17gPveTNo2HJoHiA8o4fjp0jmxjRKpAZ8g39
         ZI1Q==
X-Gm-Message-State: APjAAAVF4ldzuAip+QVZxlpbJuqnN8WfiQYwu+p9qxhscQgspLMSCrEB
        ljh2F5oe0m1Ib23dEHMOCPEwGQ==
X-Google-Smtp-Source: APXvYqwIi/hxcdCKBT8nhkcuPpLBibqtX5z6zBX66YeevnNRqdhFxGxwgLWC6u6R7O5Jdy0QVwaWtQ==
X-Received: by 2002:ae9:d803:: with SMTP id u3mr29765098qkf.131.1570562011888;
        Tue, 08 Oct 2019 12:13:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m14sm8803325qki.27.2019.10.08.12.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 12:13:31 -0700 (PDT)
Date:   Tue, 8 Oct 2019 12:13:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: make arrays static, makes object
 smaller
Message-ID: <20191008121320.59959133@cakuba.netronome.com>
In-Reply-To: <20191007120308.2392-1-colin.king@canonical.com>
References: <20191007120308.2392-1-colin.king@canonical.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 13:03:08 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate const arrays on the stack but instead make them
> static. Makes the object code smaller by 1058 bytes.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   29879	   6144	      0	  36023	   8cb7	drivers/net/phy/mscc.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   28437	   6528	      0	  34965	   8895	drivers/net/phy/mscc.o
> 
> (gcc version 9.2.1, amd64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks.
