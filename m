Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EFB686DC9
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjBASU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjBASUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D097BE70
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 919726190E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFEDC4339C;
        Wed,  1 Feb 2023 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275619;
        bh=1y2HYprnuqRXm38+oPpCA8egNdvyNzEg+EJBS24ojjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdAqA0i+vRvS5csiUy8tFduttdiVgMbI+hnKPMo8sjYIOwofLryIye9jSNH4Am2ZW
         /VtSyuxVKVRtLK/K9en2nVfJ9pI5nMXrAYm/YpUD6cm847zPffOQL+mlyNw/zWWF2L
         VciVIypXcyjSPHPg4sMn3F4722ycnoLSD7JjKE6Kl4o6GXeT6g80jG+opdScYi9Bnr
         Cs6QdLTGci5z3Z2GsXtaIVyI4LbhNRflxlaIOEk8UeCxj8mJaS8eQQXWmXwNe9Fl7A
         09ts1EGHrH/D9gERidJfPxkrtclc1abIXzazSafYjuvA9bUJSP8G9XNKgHElxLngvf
         uwbMtN0k3nj+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, vfalico@gmail.com,
        j.vosburgh@gmail.com, andy@greyhouse.net
Subject: [PATCH net 1/4] MAINTAINERS: bonding: move Veaceslav Falico to CREDITS
Date:   Wed,  1 Feb 2023 10:20:11 -0800
Message-Id: <20230201182014.2362044-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201182014.2362044-1-kuba@kernel.org>
References: <20230201182014.2362044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Veaceslav has stepped away from netdev:

Subsystem BONDING DRIVER
  Changes 96 / 319 (30%)
  Last activity: 2022-12-01
  Jay Vosburgh <j.vosburgh@gmail.com>:
    Author 4f5d33f4f798 2022-08-11 00:00:00 3
    Tags e5214f363dab 2022-12-01 00:00:00 48
  Veaceslav Falico <vfalico@gmail.com>:
  Andy Gospodarek <andy@greyhouse.net>:
    Tags 47f706262f1d 2019-02-24 00:00:00 4
  Top reviewers:
    [42]: jay.vosburgh@canonical.com
    [18]: jiri@nvidia.com
    [10]: jtoppins@redhat.com
  INACTIVE MAINTAINER Veaceslav Falico <vfalico@gmail.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: vfalico@gmail.com
CC: j.vosburgh@gmail.com
CC: andy@greyhouse.net
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index acac06b6563e..a440474a7206 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1173,6 +1173,10 @@ D: Future Domain TMC-16x0 SCSI driver (author)
 D: APM driver (early port)
 D: DRM drivers (author of several)
 
+N: Veaceslav Falico
+E: vfalico@gmail.com
+D: Co-maintainer and co-author of the network bonding driver.
+
 N: János Farkas
 E: chexum@shadow.banki.hu
 D: romfs, various (mostly networking) fixes
diff --git a/MAINTAINERS b/MAINTAINERS
index 7c884556eb8e..67b9f0c585a7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3766,7 +3766,6 @@ F:	net/bluetooth/
 
 BONDING DRIVER
 M:	Jay Vosburgh <j.vosburgh@gmail.com>
-M:	Veaceslav Falico <vfalico@gmail.com>
 M:	Andy Gospodarek <andy@greyhouse.net>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.39.1

