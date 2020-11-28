Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA762C7391
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbgK1Vt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:56 -0500
Received: from mx.der-flo.net ([193.160.39.236]:34924 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387525AbgK1T2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:28:11 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id 34E24444F9; Sat, 28 Nov 2020 20:26:58 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id BD9C04435E;
        Sat, 28 Nov 2020 20:25:47 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, john.fastabend@gmail.com,
        Florian Lehner <dev@der-flo.net>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [PATCH 0/2] Improve error handling of verifier tests
Date:   Sat, 28 Nov 2020 20:25:00 +0100
Message-Id: <20201128192502.88195-1-dev@der-flo.net>
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

Florian Lehner (2):
  selftests/bpf: Avoid errno clobbering
  selftests/bpf: Print reason when a tester could not run a program

 tools/testing/selftests/bpf/test_verifier.c | 28 ++++++++++++++++-----
 1 file changed, 22 insertions(+), 6 deletions(-)

-- 
2.28.0

