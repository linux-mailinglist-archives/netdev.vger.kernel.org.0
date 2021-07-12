Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1625B3C6538
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 22:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhGLVBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 17:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhGLVBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 17:01:42 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC97C0613DD;
        Mon, 12 Jul 2021 13:58:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w14so18327332edc.8;
        Mon, 12 Jul 2021 13:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=niPBD0dyIRlA4lqz51opoLGOWtn9Dc84UvoyaPFlzT8=;
        b=RnFo+wQ8P2EPP8bazMkfuIYGmLPacXotdtq8qwi3xK9no4vxANxfbhrzuaHXhSy78z
         YJMUnni+1rBB04/j9ZkahnXkjoVA9mV8ZmnlIIyg/KgwyaypGkWDmeEWmT1+XWy0OMNb
         KNlMXAPFyPpAH+bw8OSWvm+nPoST0HeMjdjTVm0q1ndM35HwZTR1GMcZ3LaYfxh8+qtW
         4T0HG0hU2t+CU1gMBo0CzpUbLg65eYyL/5CKAR8qEN7cESvP7Kh3QJBaHa4gAiKhAQ93
         xoLv5AP6L7IyqkRrhVoQhB5kbirKebONyYg7cs0xanlX5u3ocs2NDZlC63jJmn3N+NTE
         UKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=niPBD0dyIRlA4lqz51opoLGOWtn9Dc84UvoyaPFlzT8=;
        b=S4KbD8/ehr5jSEG+dKwOzBHGwfVqjTHajI8VVGYsNt1uj/W4fyKv7bCjQLzBOXzeXe
         1i8fuj4pT8PGknLnXqfevBdEhwDsU10XFIqPPzg1hzen/RxCaWMybjQyIxa1J6M5vPl5
         qcUZswA9rF0GFcnA6/lwR0G5xiyBw8GFu+FJJH7QgUGx3hyEUcmEZUW+Oo4oiZzbsPRe
         ZjfAsN5tYADLW9Fx7GXrPy6t9s64dSq4vU6MUvxcZCU2lAXYI3ggFNelW2UY5pq1l9Tt
         s+nylj7VCLZcXH+LwCKcRU5cMSLlzEVXvx0gH/ah0fNCO2y/mEovzNY3ZVI2leal/CPg
         PGQg==
X-Gm-Message-State: AOAM531c7/yfNKOIofBTUnX9KGXDohGn4FTKys9hU7jvD8GvfkdPEn06
        wBGA7Gq+q+A6cdIKgxyoH8F9yqdTZ4m6EA==
X-Google-Smtp-Source: ABdhPJzmR2euN7dSkl/kkLChB5SausBUl3JEvkSRSeYK8KSWA1AYcky/3XE8fkIAd+JXmsowM7zDjw==
X-Received: by 2002:a05:6402:40cf:: with SMTP id z15mr967040edb.175.1626123531203;
        Mon, 12 Jul 2021 13:58:51 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id lz19sm7196288ejb.48.2021.07.12.13.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:58:50 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:58:48 +0100
From:   Salah Triki <salah.triki@gmail.com>
To:     kevin.curtis@farsite.co.uk, davem@davemloft.net, kuba@kernel.org,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] delete useless for loop
Message-ID: <20210712205848.GA1492971@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete useless initialization of fst_card_array since the default
initialization is NULL.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/net/wan/farsync.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index b3466e084e84..0b3f561d5d5e 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2565,10 +2565,6 @@ static struct pci_driver fst_driver = {
 static int __init
 fst_init(void)
 {
-	int i;
-
-	for (i = 0; i < FST_MAX_CARDS; i++)
-		fst_card_array[i] = NULL;
 	return pci_register_driver(&fst_driver);
 }
 
-- 
2.25.1

