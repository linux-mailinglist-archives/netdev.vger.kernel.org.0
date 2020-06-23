Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63127206784
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388690AbgFWWsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387887AbgFWWrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:47:20 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92ADC061796
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:18 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x22so198197qkj.6
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8F4CsTKJlAQVv/TG6E6zFj8kQpyGDJqcusQTMDUgvC8=;
        b=vv3rGJKV13GqbdV6AP5G82f0Ru/KpJlKqkxJtRJXEE84faUBbfVHRzf75CiamLvgjm
         uix6Kf3r3BSJ/ZoAiRUem3qddy0B7P4f3rZrAhQYCpP0lHVAFmf5inhAdN6g5Kb6h92M
         Dk4P7gSaQfn5hN6s7BdxthkrAyn0gGKijWm5r6qnUNtDhmpDg/05e6dJqp8kPJOUP1Ek
         0DILB924yZPyt7dwhT3jta+cieeLk8vaDxdnFCD6Sgb67kRB/7/vYGrSwwCc5ApsDp3S
         yTca00Gnc8SD+XIp+ljJplLwDrwB7VZfj+jLSYKLa3bcUK8LAEgPBHhRjjYA7AYKWQCZ
         K4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8F4CsTKJlAQVv/TG6E6zFj8kQpyGDJqcusQTMDUgvC8=;
        b=iyMP4fXDxz/RnzQeXU8qQo+MuDrrWetQD9t2LdNq++ZOhXmh+yP2A3XJ5GIw2s3oYe
         AM+69WHb1RCSdYlmyFwXrGmqtse00AIcObgjfHqUrpHNtF6rI0W655Evf56sWMR0jogO
         BhyVRcUtq6oVlDc17/0PK/dfYWxT/bm49KzxaT2GTw5qCzbqy+UCKE9SjHdYYdfgdxeU
         5062Nr+BIjP1FRBMXtZEgGD1ZUkYR83o5KXeupPjyWO2fRUHRj3qlwWIRTMCRFtmhk13
         4JUcBk7YYGrJtameHpRLtVHtUpmShg52BfKkAcIZVgsM9BHyP5XeYWfqeDbwSB3XUvZ5
         kwSg==
X-Gm-Message-State: AOAM530TUbsTclykVzO/aP/6GZMie1wUmwAKyPvr5nJ7u3tS3YT3cHdF
        1HTuBP9EDNE34Q3OAbS4rPAvW4uMCJi5Ug==
X-Google-Smtp-Source: ABdhPJzr//N1EVMvTJJ1kOnbJ3KoMLNE7J+K73O89jSehc+ynxhjClVg4WRo+SL1gsAGIA/Yv0f1lUC3H1GQCg==
X-Received: by 2002:a0c:c602:: with SMTP id v2mr18055518qvi.220.1592951478134;
 Tue, 23 Jun 2020 15:31:18 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:31:10 -0700
Message-Id: <20200623223115.152832-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 0/5] net: adress some sparse warnings
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds missing declarations and move others to
address W=1 C=1 warnings in tcp and udp.

Eric Dumazet (5):
  tcp: add declarations to avoid warnings
  tcp: move ipv6_specific declaration to remove a warning
  tcp: move ipv4_specific to tcp include file
  net: move tcp gro declarations to net/tcp.h
  udp: move gro declarations to net/udp.h

 include/net/tcp.h       | 10 ++++++++++
 include/net/transp_v6.h |  3 ---
 include/net/udp.h       |  7 +++++++
 net/ipv4/af_inet.c      |  6 ------
 net/ipv6/ip6_offload.c  |  8 ++------
 net/mptcp/protocol.h    |  5 -----
 6 files changed, 19 insertions(+), 20 deletions(-)

-- 
2.27.0.111.gc72c7da667-goog

