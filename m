Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC60A629241
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiKOHKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiKOHKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:10:01 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FF5201BB
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:52 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 2CD6115F110D; Mon, 14 Nov 2022 23:09:35 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v3 4/4] liburing: update changelog with new feature
Date:   Mon, 14 Nov 2022 23:09:33 -0800
Message-Id: <20221115070933.1792142-5-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115070933.1792142-1-shr@devkernel.io>
References: <20221115070933.1792142-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new entry to the changelog file for the napi busy poll feature.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 CHANGELOG | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/CHANGELOG b/CHANGELOG
index 09511af..1db0269 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -1,3 +1,6 @@
+liburing-2.4 release
+- Support for napi busy polling
+
 liburing-2.3 release
=20
 - Support non-libc build for aarch64.
--=20
2.30.2

