Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F4E5A85F9
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiHaSoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiHaSob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:44:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3852F0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:44:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s15-20020a5b044f000000b00680c4eb89f1so2739146ybp.7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=dMtdPZ7MwwnKJ8RfaHJw++SbbTX12H7Tu/U1gLzcgDM=;
        b=Wo3ZzqyCy2VFie2t/7IqmAlSHgGYCjI3FRrurNhQaQTyHUoFir4ExgheBJBW/WYUj7
         HxnqOJngyJmD6xx6AGR/CwWXP7DbYva4ulU7aS9LsXEyH+nEFCJ1Eksyciwm3PM0b/HO
         9RIg/Rn0pKqpWNYRmFv/w4gt7DPrlWQuDO39eKcGtSm3M03Hf15QkFZr3NeE8YwzMNJN
         llejjt9Eam7782Ir7hO7sB1IhrfnmClpOeUByyg9l49PzqTFizJ28nQa6SksRlEs0LxR
         sp7UDQ6+M2dAun9sBQAEJWuDb5CwFGU9GTD1iYKy9PhamVqTjQi5h7f0cMZUUQLESoNO
         47+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=dMtdPZ7MwwnKJ8RfaHJw++SbbTX12H7Tu/U1gLzcgDM=;
        b=ObsyWjlBlYSGXpUuqySjz0zG8kjlaOhGSRaq8tYxyzcip2SKOXXOxXOJdJooJDo5mL
         QQMzfLnZzKeqejOvYLOcyNPW8S/RwSE21xKdzKYoTD3O21dKmDMVRQRNXBn882l0fFY2
         9tf7ATUmMAB1uOSGeEhyTQoc3OJwqeNq2DF/RBv+UbupRVtT+mJ5Us0REIOi8UrvBMDI
         yn9tUQEH1RDCiq1uMjbz6IvmUC1dbjE2jJ8XMY1UK1lJnh1RteDdSsy7PpqYmnZFe5Tf
         iOsUYz8DH/qbtnUTkw5GUqywRB3QbV9hyu+AFZibnuMSC24edgjyb9gRbLKLapZWRs56
         S3AQ==
X-Gm-Message-State: ACgBeo0ysR3kimSD4Pozcx1vRp/gT5Klp8NPrm3xZOKlK3XbITa2XxIV
        tAU/hDxI0BhVmbpxCN4E2zRMyKV3EBl5UA==
X-Google-Smtp-Source: AA6agR6bLmh0IefmFJZMsb69nY42wf9nhZlS/VyUDxqVcHYqQNHAFubbY7R7OuEbWoe3k4CvO32N+B0XNWtD0g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:46c2:0:b0:341:a26e:9d9b with SMTP id
 t185-20020a8146c2000000b00341a26e9d9bmr5407115ywa.336.1661971469331; Wed, 31
 Aug 2022 11:44:29 -0700 (PDT)
Date:   Wed, 31 Aug 2022 18:44:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831184427.119855-1-edumazet@google.com>
Subject: [PATCH net-next] net: bql: add more documentation
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some documentation for netdev_tx_sent_queue() and
netdev_tx_completed_queue()

Stating that netdev_tx_completed_queue() must be called once
per TX completion round is apparently not obvious for everybody.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eec35f9b66166161c2540446cf256790655d2398..cfe41c053e11f6bd753975c2aaee51314c4a7349 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3353,6 +3353,16 @@ static inline void netdev_txq_bql_complete_prefetchw(struct netdev_queue *dev_qu
 #endif
 }
 
+/**
+ *	netdev_tx_sent_queue - report the number of bytes queued to a given tx queue
+ *	@dev_queue: network device queue
+ *	@bytes: number of bytes queued to the device queue
+ *
+ *	Report the number of bytes queued for sending/completion to the network
+ *	device hardware queue. @bytes should be a good approximation and should
+ *	exactly match netdev_completed_queue() @bytes.
+ *	This is typically called once per packet, from ndo_start_xmit().
+ */
 static inline void netdev_tx_sent_queue(struct netdev_queue *dev_queue,
 					unsigned int bytes)
 {
@@ -3398,13 +3408,14 @@ static inline bool __netdev_tx_sent_queue(struct netdev_queue *dev_queue,
 }
 
 /**
- * 	netdev_sent_queue - report the number of bytes queued to hardware
- * 	@dev: network device
- * 	@bytes: number of bytes queued to the hardware device queue
+ *	netdev_sent_queue - report the number of bytes queued to hardware
+ *	@dev: network device
+ *	@bytes: number of bytes queued to the hardware device queue
  *
- * 	Report the number of bytes queued for sending/completion to the network
- * 	device hardware queue. @bytes should be a good approximation and should
- * 	exactly match netdev_completed_queue() @bytes
+ *	Report the number of bytes queued for sending/completion to the network
+ *	device hardware queue#0. @bytes should be a good approximation and should
+ *	exactly match netdev_completed_queue() @bytes.
+ *	This is typically called once per packet, from ndo_start_xmit().
  */
 static inline void netdev_sent_queue(struct net_device *dev, unsigned int bytes)
 {
@@ -3419,6 +3430,15 @@ static inline bool __netdev_sent_queue(struct net_device *dev,
 				      xmit_more);
 }
 
+/**
+ *	netdev_tx_completed_queue - report number of packets/bytes at TX completion.
+ *	@dev_queue: network device queue
+ *	@pkts: number of packets (currently ignored)
+ *	@bytes: number of bytes dequeued from the device queue
+ *
+ *	Must be called at most once per TX completion round (and not per
+ *	individual packet), so that BQL can adjust its limits appropriately.
+ */
 static inline void netdev_tx_completed_queue(struct netdev_queue *dev_queue,
 					     unsigned int pkts, unsigned int bytes)
 {
-- 
2.37.2.672.g94769d06f0-goog

