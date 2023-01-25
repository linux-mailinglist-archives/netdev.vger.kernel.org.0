Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8743367B653
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbjAYPxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbjAYPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:53:14 -0500
Received: from mail.sven.de (paix.mosquito.net [37.187.101.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0735E1EFD5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:53:11 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.sven.de (Postfix) with ESMTPSA id 98DC7C002AC;
        Wed, 25 Jan 2023 16:53:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sven.de; s=default;
        t=1674661989; bh=lP4bqExk5qdRVqrUQ6yr8ZK2BhHWsmbCieBxVhm2iJs=;
        h=Date:Subject:To:References:Cc:From:In-Reply-To;
        b=H62qXA7Ucb+2/AWYT7Fx3mXEWHOKtZ8Z6mXScSjvxFbRudC8czoE4HEno3MQNAmzv
         HWFIF+t1TK5YtGw/m1wxbT6CyE1y4DuG7SXZSDO42nFqV84eaxhXTETyl4ZOBVGdQJ
         ueE93gM6YwHqdW8wXMo4MzYIx/EvIIOEwecDEH8k=
Message-ID: <1f93526f-02b0-8554-265e-e03d7b04552e@sven.de>
Date:   Wed, 25 Jan 2023 16:53:08 +0100
MIME-Version: 1.0
Subject: [PATCH iproute2 v2 1/1] ip-rule.8: Bring synopsis in line with
 description
To:     netdev@vger.kernel.org
References: <2d32d885-6d27-7cb9-e1e6-c179c2f4d8c5@sven.de>
Cc:     sven-netdev@sven.de
From:   Sven Neuhaus <sven-netdev@sven.de>
In-Reply-To: <2d32d885-6d27-7cb9-e1e6-c179c2f4d8c5@sven.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Neuhaus <sven-netdev@sven.de>

Bring ip-rule.8 synopsis in line with description

The parameters "show" and "priority" were listed in the synopsis using
other aliases than in the description.

Signed-off-by: Sven Neuhaus <sven-netdev@sven.de>
---
V1 -> V2: Include Simon Horman's suggestion, adding "show".
  man/man8/ip-rule.8 | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/man8/ip-rule.8 b/man/man8/ip-rule.8
index 2c12bf64..743d88c6 100644
--- a/man/man8/ip-rule.8
+++ b/man/man8/ip-rule.8
@@ -15,7 +15,7 @@ ip-rule \- routing policy database management

  .ti -8
  .B  ip rule
-.RB "[ " list
+.RB "[ " show
  .RI "[ " SELECTOR " ]]"

  .ti -8
@@ -42,8 +42,8 @@ ip-rule \- routing policy database management
  .IR STRING " ] [ "
  .B  oif
  .IR STRING " ] [ "
-.B  pref
-.IR NUMBER " ] [ "
+.B  priority
+.IR PREFERENCE " ] [ "
  .IR l3mdev " ] [ "
  .B uidrange
  .IR NUMBER "-" NUMBER " ] [ "
-- 
2.30.1
