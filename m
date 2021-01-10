Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504812F0483
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbhAJATg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJATg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 234BE2388A;
        Sun, 10 Jan 2021 00:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610237935;
        bh=89IEbIv/zBauo1jPANVi6Sicq1KNOKL6cCPni7pVWtc=;
        h=From:To:Cc:Subject:Date:From;
        b=eNiKHzSHoeYHQ5KYcBXCL1ohgfL3j+0YbRW5eSYy11PJZKkBcCJiabgTibxziX7go
         1ngfU6u7vBd23ynBz9Z7I2mFNv+o6l1+irUTt9wpbvbTgXZn8U9hW0mVtmKI4Xesl1
         Cixg7Yo3AbFmDXAZXqrK9G9ZeeJFwVea8yYJ42qhYyZYKArWfVosd2CT+56gzMjO55
         3aGQA889uK/suwVazCnZ7UkoFe/ol85ql6DYaocwDDJ8XWcByaYCvUAbBl/q2v6Ern
         /058EKA7h+frD8GZAN/7stQoruuEdFuwS56v7j/qDpwXAnszZ0GzEgQ2pizWfOtO6P
         OfIM1IKh/55tA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v2 00/11] selftests: Updates to allow single instance of nettest for client and server
Date:   Sat,  9 Jan 2021 17:18:41 -0700
Message-Id: <20210110001852.35653-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update nettest to handle namespace change internally to allow a
single instance to run both client and server modes. Device validation
needs to be moved after the namespace change and a few run time
options need to be split to allow values for client and server.

David Ahern (11):
  selftests: Move device validation in nettest
  selftests: Move convert_addr up in nettest
  selftests: Move address validation in nettest
  selftests: Add options to set network namespace to nettest
  selftests: Add support to nettest to run both client and server
  selftests: Use separate stdout and stderr buffers in nettest
  selftests: Add missing newline in nettest error messages
  selftests: Make address validation apply only to client mode
  selftests: Consistently specify address for MD5 protection
  selftests: Add new option for client-side passwords
  selftests: Add separate options for server device bindings

 tools/testing/selftests/net/fcnal-test.sh | 398 +++++++--------
 tools/testing/selftests/net/nettest.c     | 576 +++++++++++++++-------
 2 files changed, 595 insertions(+), 379 deletions(-)

-- 
2.24.3 (Apple Git-128)

