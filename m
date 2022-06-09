Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56BC545078
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344322AbiFIPRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344133AbiFIPRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:17:23 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0FF49F20;
        Thu,  9 Jun 2022 08:17:21 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id x75so14515062qkb.12;
        Thu, 09 Jun 2022 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yo55hjPkaA6HUYV2samiBI0zS/levO2yum2VLOtoWjk=;
        b=Dvi7HQuDWWhipcp138Bj87WO5wxvawZn2bzyTZQ4AbTQyWsLoYJ8swA+P0vckDmIUt
         GrEov9w1T1rzITJHfzMPOGbhL6MScASG7TVPv+mEFe6Z+UfSwRfy2Vy6Ga6lxp5maTVb
         NG9pAEtuXlrKOGITy7Gr7LRTe3cmuIeXH8zXet1WClibKdVgvToLEAo/rx92orcRl70r
         z/t3F8lq8yTFEyhT28TiJHTA3zi8V27nrH3CxLgEJclEfSNzZqrv/+91CENs04bYtdST
         WUvPE5KkrmIF5X1L/VMzDQbVYZhWkUhsEl76BI959f/1zw02Iz/q/3UDZYqUwKDD9MxG
         fhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yo55hjPkaA6HUYV2samiBI0zS/levO2yum2VLOtoWjk=;
        b=auRn75/CVauQnfFFD7mieJbTJZA+yWLZso85DILYzCP8dM9QNralDYHypbJGcB42J/
         +GD8G62z7g5mEUQVH+AYYCnZFbyezRO3nmDC+u8X8YKj8zd55qYEJTQvh3OmUmi+UCXT
         NKr71nPfL9Z1h7gLwUFUZweScspaijUiPgaEWjGfeT96HBCizsh6WHet+UFYRIOtOCNf
         Beao2ICOdO+MRaOoLm5VVJaqgsrrLpfznbz9GxZoqdIA0rmKLFKArAbYdEQKDwp6xtBX
         wUNMBnkfoZ8WhQkN9iZFH/R2nC6Yi89o+qBFdv91Dn6kdssaRH8dUea95KkakMlIVvff
         eVtw==
X-Gm-Message-State: AOAM532do5iyui+VPq+S5GGvO1fb0s5iSnisXIoM+S0Vv6ILJlMKW+87
        5jtzSCp+YTS5oJcto2i+JlnmxZYKvm0Pozy/
X-Google-Smtp-Source: ABdhPJzy3K+VDHswkyZ44WSM6TvCJBMe1MNYY9ptV0Er9EXbeQ7eUxgTCkF6NanGTZoClhe1VXY0DA==
X-Received: by 2002:a05:620a:1272:b0:6a6:bdc1:8f92 with SMTP id b18-20020a05620a127200b006a6bdc18f92mr14865562qkl.330.1654787840188;
        Thu, 09 Jun 2022 08:17:20 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id n64-20020a37bd43000000b006a60190ed0fsm18199469qkf.74.2022.06.09.08.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:17:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCHv2 net 3/3] Documentation: add description for net.sctp.ecn_enable
Date:   Thu,  9 Jun 2022 11:17:15 -0400
Message-Id: <5134901d42a9de34ebcc8726ef147688686537a8.1654787716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1654787716.git.lucien.xin@gmail.com>
References: <cover.1654787716.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe it in networking/ip-sysctl.rst like other SCTP options.

Fixes: 2f5268a9249b ("sctp: allow users to set netns ecn flag with sysctl")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 5d90e219398c..f709e368808d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2955,6 +2955,18 @@ intl_enable - BOOLEAN
 
 	Default: 0
 
+ecn_enable - BOOLEAN
+        Control use of Explicit Congestion Notification (ECN) by SCTP.
+        Like in TCP, ECN is used only when both ends of the SCTP connection
+        indicate support for it. This feature is useful in avoiding losses
+        due to congestion by allowing supporting routers to signal congestion
+        before having to drop packets.
+
+        1: Enable ecn.
+        0: Disable ecn.
+
+        Default: 1
+
 
 ``/proc/sys/net/core/*``
 ========================
-- 
2.31.1

