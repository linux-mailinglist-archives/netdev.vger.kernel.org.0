Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABE41A3A7C
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgDIT1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:27:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDIT1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 15:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=+5HMUCNkBVOds9Hf/9KeHJiap771cuhlz8kud+ZiLWY=; b=ZgCNo4SbLps0p9NgnX6jSERIJy
        hDuO1WRGovf9VWVNfN2o58uSYQWFO4bBWZWzhNqlcCEYmqiaeWHMZSbrCwn/ra2EeJoyzJgKCiyGZ
        y7lNcbnCMFk+ZGSqPdUxxIOEO8sztcfkB/cOdtj4siwHTn2y8dGUu/6EHYdvu5sSi01VNMqes1QHR
        3RakVPS5YeiNaS8vtrrmbR1nQ+FgzVCmuq4r1DvnMNzkgDXQvtNI9LDUyiBGe6kjZmKJJVyevmtpt
        i64gLnyTl9SZahWCTGDnBfS18fVDx1DGGtzJjxp0zXoYMA3omYHndtoqLQyLb2PqyfitR2fxvuOnc
        28vGbA2Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMcpa-0005Ge-SY; Thu, 09 Apr 2020 19:27:18 +0000
Subject: [PATCH net] docs: networking: add full DIM API
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, talgi@mellanox.com,
        leon@kernel.org, jacob.e.keller@intel.com
References: <20200409175704.305241-1-kuba@kernel.org>
 <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
Message-ID: <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
Date:   Thu, 9 Apr 2020 12:27:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add the full net DIM API to the net_dim.rst file.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: davem@davemloft.net
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
---
Applies on top of Jakub's patch: [PATCH net] docs: networking: convert DIM to RST

I do have patches similar to Jakub's patch, but I haven't sent them yet.
Anyway, the only significant difference it this small [optional] change.

 Documentation/networking/net_dim.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20200409.orig/Documentation/networking/net_dim.rst
+++ linux-next-20200409/Documentation/networking/net_dim.rst
@@ -178,3 +178,9 @@ usage is not complete but it should make
 	INIT_WORK(&my_entity->dim.work, my_driver_do_dim_work);
 	...
   }
+
+Dynamic Interrupt Moderation (DIM) library API
+==============================================
+
+.. kernel-doc:: include/linux/dim.h
+    :internal:

