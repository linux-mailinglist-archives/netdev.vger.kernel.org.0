Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE6F64BFA3
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiLMWwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLMWwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:52:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A801C129
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 14:52:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E53DD61767
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6CBC433D2;
        Tue, 13 Dec 2022 22:52:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ast5lEL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670971939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UnkeF6MoUcMHt9VnSs6bBdWQSmzmTOY5u4eR1/3XUcg=;
        b=Ast5lEL4abjQeXMEhoSdWoLZdWTRhlIWUjKoBvKgJxVwbF0fHpH4tJnI4LhEQLSS825oZj
        UqGX/0Z7rFdFNIdj6+J6xyaxQaWGMslY9D4dReGWh7dGCmyNAHRBqCkU7TZre36uGF6PxG
        jBf1ibECrzjES0yd7Q/n8VlOaDp9Pw8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a537dc14 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 13 Dec 2022 22:52:18 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/1] wireguard patches for 6.2-rc1
Date:   Tue, 13 Dec 2022 15:52:07 -0700
Message-Id: <20221213225208.3343692-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub & Folks,

This tiny pull just has a single patch to ready wireguard for gcc 13,
casting some arguments to pr_debug to an (int) explicitly, because gcc
13 changes the type of enums.

Since this is just a fix, I've marked it as 'net', but if you prefer to
do it via 'net-next', that's fine too.

Jason

Jiri Slaby (SUSE) (1):
  wireguard: timers: cast enum limits members to int in prints

 drivers/net/wireguard/timers.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.39.0

