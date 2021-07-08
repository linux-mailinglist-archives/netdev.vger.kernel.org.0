Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61C23C189F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhGHRvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhGHRvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:51:08 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6788C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 10:48:26 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q190so6514065qkd.2
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 10:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cpa3y006zKcQ4B4rroTm1HtUkWv/v/BjCMFz89RLVQg=;
        b=0MZ0APYfC9ELcGl7AvgIgdc1/tjNSqnNyNCzOqO3+b/lSkqNVNPFuQ9V8X8cPVN1SS
         Wj4QqmvKrOkbuK59711k3CyLWcdeiSlcqF3GLplLK9OXVon3sggzCQHQeTrTrnHTqHy5
         7+BJKcxlookt8/y2a8Bi8fizooY83i5nqmOTlfPXMIXxhDb6t7eSHvY2XK5F9HTJDcup
         DQ6mQTKLFYawjiOtlyaGFN2VLIkzJx4liO/kvCyTgKezg1VO6VlRNuNbQYK4f6A/UC08
         wyUFml9dIRBERDSrtv6hoOWJDF7vf4vVptj68kypERezDvYFhwWQS8emhiWtPInPvgwV
         eTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Cpa3y006zKcQ4B4rroTm1HtUkWv/v/BjCMFz89RLVQg=;
        b=V3Fe4yvzaWFvXds2MVJfb/u0loO5Aay7iL5l0zrMISyP2Zgq0VfrxEH9wR8cK9n2J6
         OW4u1wr/sWFU3EZMklj5KoJYvHmFz4kkBk2Bn9yyhqKFOMW9OgpYPfpvcy05b3hxtkLl
         iCWfytSoNp8ZQnC4dyt8/4bj2OGXDysbJ7RQM65YSvqs1kW6XmA2Kp/gquZVdxc+GjDW
         xtvBP+66PPNH76VQqzoFVzHbXYQrfhIY3fL0yhTQ5GGBEaEajx4oYyrht0ny/wXSPRYk
         c/M2Zc/n1Caq3YJayoGEGCHjtxoN7+JC/984/E3U/WIJ/zUzOY90cgMReuPhzCbf3F3Y
         2cHA==
X-Gm-Message-State: AOAM530Dz42yuq5UV0xYheUfOYmp8oHE36GoiXJ/+MpexAbm5vi8RjIi
        S7DYADRUW5khSMY5lFjLG1qlyQ==
X-Google-Smtp-Source: ABdhPJwLAfSqQ3PbvL4Vd4UqFTU4Ks40vdLtYuIGYRthvSUsGnJZKLYe1pBUNobIAnfy2Wei9fyvJQ==
X-Received: by 2002:a37:bbc7:: with SMTP id l190mr33282286qkf.424.1625766505969;
        Thu, 08 Jul 2021 10:48:25 -0700 (PDT)
Received: from iron-maiden.localnet ([50.225.136.98])
        by smtp.gmail.com with ESMTPSA id a201sm1250616qkc.46.2021.07.08.10.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 10:48:25 -0700 (PDT)
From:   Carlos Bilbao <bilbao@vt.edu>
To:     davem@davemloft.net, Joe Perches <joe@perches.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        gregkh@linuxfoundation.org
Subject: [PATCH net-next v2] drivers: ethernet: tulip: Fix indentation of printk
Date:   Thu, 08 Jul 2021 13:48:24 -0400
Message-ID: <4352381.cEBGB3zze1@iron-maiden>
Organization: Virginia Tech
In-Reply-To: <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
References: <1884900.usQuhbGJ8B@iron-maiden> <5183009.Sb9uPGUboI@iron-maiden> <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix indentation of printk that starts at the beginning of the line and does
not have a KERN_<LEVEL>.

Signed-off-by: Carlos Bilbao <bilbao@vt.edu>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index b125d7faefdf..0d8ddfdd5c09 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
 
     default:
 	lp->tcount++;
-printk("Huh?: media:%02x\n", lp->media);
+	printk(KERN_NOTICE "Huh?: media:%02x\n", lp->media);
 	lp->media = INIT;
 	break;
     }
-- 
2.25.1



