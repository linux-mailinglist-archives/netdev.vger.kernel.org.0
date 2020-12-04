Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889152CF3DE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgLDSUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:20:12 -0500
Received: from mx.der-flo.net ([193.160.39.236]:40136 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgLDSUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:20:11 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id A5F9744588; Fri,  4 Dec 2020 19:19:29 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1205:34c2:d100:56f5:35da:21bf:c38d])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id EEE0C42592;
        Fri,  4 Dec 2020 19:18:39 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, john.fastabend@gmail.com,
        Florian Lehner <dev@der-flo.net>
Subject: [PATCH 0/2 v3] Improve error handling of verifier tests
Date:   Fri,  4 Dec 2020 19:18:26 +0100
Message-Id: <20201204181828.11974-1-dev@der-flo.net>
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

v3:
  - Add explicit fallthrough

v2:
  - Add unpriv check in error validation

Florian Lehner (2):
  selftests/bpf: Print reason when a tester could not run a program
  selftests/bpf: Avoid errno clobbering

 tools/testing/selftests/bpf/test_verifier.c | 31 +++++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
2.28.0

