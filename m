Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA72F02EA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 19:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAISyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 13:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbhAISyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 13:54:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B630023975;
        Sat,  9 Jan 2021 18:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610218442;
        bh=89IEbIv/zBauo1jPANVi6Sicq1KNOKL6cCPni7pVWtc=;
        h=From:To:Cc:Subject:Date:From;
        b=NwpLt5Mo3h4ogRIXNZ9OUZYSNKiaB3BrEAkI4OsGRm+iwAnqxgtPuIF7WD0KZMZOV
         oNKFEj7I9ehTGCPG7wg4r83l3YSnMz7l76yk78JxgmBmDFlVITDvidsjCb52OGEntI
         1ebEuQDMxgRHNkU5IeHh16oqhgUt9/i9NKQTaJr9Z7s1E1TEbXY2ToFa3fceIm9pu6
         ZRufi4ymBdKtfKUoofh7mr1msXKLD973xRf6wBTLIrlZ0bBn631zYKL2hQDzF73ULR
         FOS41ket+kZadebLfq1AIz4kF5B0CjkeP3EnQ256WoT5cU5ge65chBpvPbV7YCj3yp
         guyGpWJxXLwpQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH 00/11] selftests: Updates to allow single instance of nettest for client and server
Date:   Sat,  9 Jan 2021 11:53:47 -0700
Message-Id: <20210109185358.34616-1-dsahern@kernel.org>
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

