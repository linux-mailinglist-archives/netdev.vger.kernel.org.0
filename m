Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7CC33F56E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhCQQ0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhCQQZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:25:53 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D6C06174A;
        Wed, 17 Mar 2021 09:25:53 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id c131so41099465ybf.7;
        Wed, 17 Mar 2021 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=tqhUCZlgyOgpiZKelh228iIEYPXaSPsmgn7O814UVFc=;
        b=dVA6InQIRl48BUX7kPCoWFFYYl0i9rYA6PfCpntt0y/kJLi2pYweTe6a1uIZl5O7a8
         SMGAZfOOs49DxbF6HpBiXLkLfFqzm9Xf2o1ozJYv9GR2nVJdAZxIg7639N4OmTdgVaes
         WKWEQCVir1kCN4bAZQFoEUciVhCP8brUJS2p0R/P/JJONodBRW1X2m+2hOQipQnUFsyc
         a1S7QUn3C5Ou4xWBc70kEE3vmEb43xxwMw7bL0+Otsw7AeIzuHnhdwHB3UIkfPAVm2NN
         HgFyIBf4xaGFPnq9e14gkPO4liJY7SZEpnHxtg+CCEszldo1KrInNfDIuufZcrwSrKRX
         EX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=tqhUCZlgyOgpiZKelh228iIEYPXaSPsmgn7O814UVFc=;
        b=IXO/mc15W+GHlx58f4hVAuYQ6Cds1CRwfVIBib//UmlB5gQLq6hbeE31z168vJrCpT
         XeUDdaxze6tkM6SoyEoAT0ZsgyeihNcvKZ5qNuOxQXglRV2BJi/xQr+pX4fq/RxZIfMS
         wFtfHgbWLb0HlFeYhPcVaVChznlKuEsJuAbCPPBs/VhNNDCA58SmpFAX9fPDlDt3+PWG
         KPl5fpBeTAVtp3UP6UnEwD8U2KiLocWdbdTarH4R6Vz5XBl8ObPOpyUDiQkGr+LKW8EQ
         aPxWpLBbYazX4dUdLXdVzJR+Ln1IRf2u8RvITfeVlzscGWh62uMzX8X+W3ndgmZ0hp2i
         tmqQ==
X-Gm-Message-State: AOAM530RjtI5JiL2PrbZdxZkjLb0mRW++e+MUSvj30HnBnDWIbYFwbyd
        DvZ8aCvJ+m0Bs5AqsRZoWagxBTLOHEOo6pbcpz9M9FveMNoG6Q==
X-Google-Smtp-Source: ABdhPJzpEpWmCYl3eQVf+z82V5WsEdzj9GmpbcPG8zHvwWRSU+W2kAUXhCHpTg8+2vTwkTBdYNOui3PIJytTWU4DJdM=
X-Received: by 2002:a25:ca46:: with SMTP id a67mr4779837ybg.166.1615993659899;
 Wed, 17 Mar 2021 08:07:39 -0700 (PDT)
MIME-Version: 1.0
From:   Anish Udupa <udupa.anish@gmail.com>
Date:   Wed, 17 Mar 2021 20:37:28 +0530
Message-ID: <CAPDGunOVtW5mZWXwEjtT3qWXNG4WgkdEa3jV79QKVHOmjHU-9Q@mail.gmail.com>
Subject: [PATCH] net: ipv4: Fixed some styling issues.
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ran checkpatch and found these warnings. Fixed some of them in this patch.
a) Added a space before '='.
b) Removed the space before the tab.

Signed-off-by: Anish Udupa H <udupa.anish@gmail.com>
---
 net/ipv4/route.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 02d81d79deeb..0b9024584fde 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2236,7 +2236,7 @@ out: return err;
  if (!rth)
  goto e_nobufs;

- rth->dst.output= ip_rt_bug;
+ rth->dst.output = ip_rt_bug;
 #ifdef CONFIG_IP_ROUTE_CLASSID
  rth->dst.tclassid = itag;
 #endif
@@ -2244,9 +2244,9 @@ out: return err;

  RT_CACHE_STAT_INC(in_slow_tot);
  if (res->type == RTN_UNREACHABLE) {
- rth->dst.input= ip_error;
- rth->dst.error= -err;
- rth->rt_flags &= ~RTCF_LOCAL;
+ rth->dst.input = ip_error;
+ rth->dst.error = -err;
+ rth->rt_flags &= ~RTCF_LOCAL;
  }

  if (do_cache) {
-- 
2.17.1
