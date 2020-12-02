Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED42CC6F5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgLBTsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgLBTsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:48:08 -0500
Received: from mx.der-flo.net (mx.der-flo.net [IPv6:2001:67c:26f4:224::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F7BC0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 11:47:13 -0800 (PST)
Received: by mx.der-flo.net (Postfix, from userid 110)
        id DBBB344563; Wed,  2 Dec 2020 20:46:56 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 2FCA744552;
        Wed,  2 Dec 2020 20:46:15 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, john.fastabend@gmail.com,
        Florian Lehner <dev@der-flo.net>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [PATCH 0/2 v2] Improve error handling of verifier tests
Date:   Wed,  2 Dec 2020 20:45:30 +0100
Message-Id: <20201202194532.12879-1-dev@der-flo.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches improve the error handling for verifier tests. With "Test
the 32bit narrow read" Krzesimir Nowak provided these patches first, but
they were never merged.
The improved error handling helps to implement and test BPF program types
that are not supported yet.

v2:
  - Add unpriv check in error validation

Florian Lehner (2):
  selftests/bpf: Print reason when a tester could not run a program
  selftests/bpf: Avoid errno clobbering

 tools/testing/selftests/bpf/test_verifier.c | 30 ++++++++++++++++-----
 1 file changed, 24 insertions(+), 6 deletions(-)

--
2.28.0

