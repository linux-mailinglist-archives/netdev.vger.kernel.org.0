Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7762632CC8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiKUTPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiKUTPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:15:33 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB14AD39D5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:15:19 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 9D05D1B81314; Mon, 21 Nov 2022 11:15:00 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [PATCH v5 4/4] liburing: update changelog with new feature
Date:   Mon, 21 Nov 2022 11:14:59 -0800
Message-Id: <20221121191459.998388-5-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121191459.998388-1-shr@devkernel.io>
References: <20221121191459.998388-1-shr@devkernel.io>
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

