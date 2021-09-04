Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4336D400D8A
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 01:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhIDXdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 19:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhIDXdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 19:33:19 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BDEC061575
        for <netdev@vger.kernel.org>; Sat,  4 Sep 2021 16:32:17 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id E2F4FC01E; Sun,  5 Sep 2021 01:32:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1630798333; bh=nOfaWTYwk98KF6mMTmqMhyfAnFyeQo6SqpTGB9sKYnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aVE99f9lL9ydrG28zmuY3MUXvmNPSDU7Dw20bIJylpzDMQmAhoARIwrfKBu1h/A/f
         Xpszba4tSIycA6+Ao1GVaQYiKKN7NG+Pa7BYxDyN2yegTZj1Nijwg9M+8kW7coCpye
         Hi8ETrrd9v/JTOqeIdmCVJBtXO3Jml+PhyGz6wZUwVN48lKbYa+BvOazATehghTi7P
         4f9K922jcSTpVs/5DQpe+yR4YT8iTWu83Lv5QC4ukkc+3MFPddR6hW/uHsYe/22J3R
         q0t+GcbBM6Ke81REjylG6debeFnT5HaqwRGfasQTtawyOh0xNx4aZ+4p9t15ByVgi7
         q2/wCrm7zXd4g==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id B927CC009;
        Sun,  5 Sep 2021 01:32:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1630798331; bh=nOfaWTYwk98KF6mMTmqMhyfAnFyeQo6SqpTGB9sKYnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m1GP+jpVhXBucISDFwez0aHyZH5QL+VB6S217+VepD9NUYLtFen8m9XVgvAE8irL1
         yxrXpWsPyhNqOYRtNQ3YF/gNOXWUXUTzciRlCUV8+xYp7MKuxgMyQkrYxntuO4RvMN
         lnYfs0zIXGPtg9prE3iJ4aod75ngvulh6gd5u8oNW6F6cvzJq4235buUaAPZ+6xF9X
         07EcT5gP5PVdE8a1T4O7m2fxpABpC4Ah1Gr/fEpHRhxoWIRQI6DyzsBKH+GSRgUMtr
         tONuY3UIUytuDo7xpf2Yzef/mPZh0PK9q5lp5oSgG3rJD3f4EbLwLpyIcrGC0ihLXR
         lD/LDYNymGThg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 3ff36f2b;
        Sat, 4 Sep 2021 23:32:06 +0000 (UTC)
Date:   Sun, 5 Sep 2021 08:31:50 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH 2/2] net/9p: increase default msize to 128k
Message-ID: <YTQB5jCbvhmCWzNd@codewreck.org>
References: <cover.1630770829.git.linux_oss@crudebyte.com>
 <61ea0f0faaaaf26dd3c762eabe4420306ced21b9.1630770829.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <61ea0f0faaaaf26dd3c762eabe4420306ced21b9.1630770829.git.linux_oss@crudebyte.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

thanks for the follow up, this has been on my todolist forever and
despite how simple it is I never took the time for it...


I've applied both patches to my -next branch... We're a bit tight for
this merge window (v5.15) but I'll send it to linux mid next week anyway.


I've also added this patch (sorry for laziness) for TCP, other transports
are OK iirc:

From 657e35583c70bed86526cb8eb207abe3d55ea4ea Mon Sep 17 00:00:00 2001
From: Dominique Martinet <asmadeus@codewreck.org>
Date: Sun, 5 Sep 2021 08:29:22 +0900
Subject: [PATCH] net/9p: increase tcp max msize to 1MB

Historically TCP has been limited to 64K buffers, but increasing msize provides
huge performance benefits especially as latency increase so allow for bigger buffers.

Ideally further improvements could change the allocation from the current contiguous chunk
in slab (kmem_cache) to some scatter-gather compatible API...

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index f4dd0456beaf..007bbcc68010 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -34,7 +34,7 @@
 #include <linux/syscalls.h> /* killme */
 
 #define P9_PORT 564
-#define MAX_SOCK_BUF (64*1024)
+#define MAX_SOCK_BUF (1024*1024)
 #define MAXPOLLWADDR   2
 
 static struct p9_trans_module p9_tcp_trans;
-- 
Dominique
