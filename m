Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD8DFA05
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfJVBCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfJVBCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 21:02:46 -0400
Received: from localhost.localdomain (c-73-169-115-106.hsd1.co.comcast.net [73.169.115.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D152166E;
        Tue, 22 Oct 2019 01:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571706166;
        bh=EfxL9OucbdQwXoutE0oMf4R9Qjm3BumsTArWE4d6BI8=;
        h=From:To:Cc:Subject:Date:From;
        b=xjiBMmxXPCjhpEzS5Bl34h1JaSsRtgXYKawXlcehxfkDSvg1T442sI9iavttZ7AZA
         4DGHQlN1TUTkPAkn1Z12x1p7gO0mOjFHBmdZZ6sma5xvzRzW7H+hTYQCz9VrjT+/KU
         Uu0ol0r73CUH6yfOdYU45LWRKdppjzJGIOplfYP0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH net] selftests: Make l2tp.sh executable
Date:   Mon, 21 Oct 2019 19:02:43 -0600
Message-Id: <20191022010243.60916-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Kernel test robot reported that the l2tp.sh test script failed:
    # selftests: net: l2tp.sh
    # Warning: file l2tp.sh is not executable, correct this.

Set executable bits.

Fixes: e858ef1cd4bc ("selftests: Add l2tp tests")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/l2tp.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/net/l2tp.sh

diff --git a/tools/testing/selftests/net/l2tp.sh b/tools/testing/selftests/net/l2tp.sh
old mode 100644
new mode 100755
-- 
2.20.1 (Apple Git-117)

