Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4CB183F7C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgCMDR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgCMDR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:17:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2948206F1;
        Fri, 13 Mar 2020 03:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584069479;
        bh=ILsiPrMpW6mU90mqVPtgUQTlUdPd/plHtmWNc9Q6XIU=;
        h=From:To:Cc:Subject:Date:From;
        b=QLRNG/I7Fa5eDgBsuvaqvSZ0khZ8IMKgY/sCwP6iR2j6dPHFFS52WQQBg10wKJHoR
         5B7BRqjsSZkg/UtIviFo27RVvj3YdZFrzUgt8Ihw9H0cDwJN1qDPQQtnJuK7Whualu
         z+3p3lTXTP3otQEMTuHyjzQKbV26mQpJhOcBVYJU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org
Cc:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/5] kselftest: add fixture parameters
Date:   Thu, 12 Mar 2020 20:17:47 -0700
Message-Id: <20200313031752.2332565-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set is an attempt to make running tests for different
sets of data easier. The direct motivation is the tls
test which we'd like to run for TLS 1.2 and TLS 1.3,
but currently there is no easy way to invoke the same
tests with different parameters.

Tested all users of kselftest_harness.h.

Jakub Kicinski (5):
  selftests/seccomp: use correct FIXTURE macro
  kselftest: create fixture objects
  kselftest: run tests by fixture
  kselftest: add fixture parameters
  selftests: tls: run all tests for TLS 1.2 and TLS 1.3

 Documentation/dev-tools/kselftest.rst         |   3 +-
 tools/testing/selftests/kselftest_harness.h   | 228 +++++++++++++++---
 tools/testing/selftests/net/tls.c             |  93 ++-----
 tools/testing/selftests/seccomp/seccomp_bpf.c |  10 +-
 4 files changed, 213 insertions(+), 121 deletions(-)

-- 
2.24.1

