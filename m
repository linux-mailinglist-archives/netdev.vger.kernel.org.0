Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C2556CB90
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 23:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiGIVVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 17:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGIVVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 17:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F68193F9;
        Sat,  9 Jul 2022 14:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA8460FD6;
        Sat,  9 Jul 2022 21:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F872C3411E;
        Sat,  9 Jul 2022 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657401683;
        bh=L3YqTVtj2quQbUWGetdHlZbPD/g3nkXrE6pzg8xh81k=;
        h=From:To:Cc:Subject:Date:From;
        b=t2jRjcqyW0PNdMBdCUhgeVt7/xXy/UYDSgtCozRGHV/3RhkUvjo6lbVYmgJQ7gWkR
         AeEKjqTmvXJX+5OEZYSoeuwdprfqB2wgvwxxF7TchUZeoN46WhaOm56X9PgBxV+gpL
         n5ik/TrnJqMQFrJ2BybiJScARGg7T1Lk6JVGVc3G8YZcKVY8hW9PKS4NpKhbpVFpFF
         T3XV1CdNxqbwCnsA/OQA2W8gBgW96ZIWoLO/ZwrFk535oY1q5SZ7CSZEe/BKVIbKbO
         rxCP9Q53H/fPppQzogZR8C9Jzm0brBKiqlYjQOUMF/x0fG++eOZz7TQwz3Jnu76ggB
         mQ6gDWKUHxlpg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Subject: [PATCH 0/2] crypto: make the sha1 library optional
Date:   Sat,  9 Jul 2022 14:18:47 -0700
Message-Id: <20220709211849.210850-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes it possible to build the kernel without SHA-1 support,
although for now this is only possible in minimal configurations, due to
the uses of SHA-1 in the networking subsystem.

Eric Biggers (2):
  crypto: move lib/sha1.c into lib/crypto/
  crypto: make the sha1 library optional

 crypto/Kconfig          | 1 +
 init/Kconfig            | 1 +
 lib/Makefile            | 2 +-
 lib/crypto/Kconfig      | 3 +++
 lib/crypto/Makefile     | 3 +++
 lib/{ => crypto}/sha1.c | 0
 net/ipv6/Kconfig        | 1 +
 7 files changed, 10 insertions(+), 1 deletion(-)
 rename lib/{ => crypto}/sha1.c (100%)


base-commit: 79e6e2f3f3ff345947075341781e900e4f70db81
-- 
2.37.0

