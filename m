Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCDE43FFD9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhJ2PyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhJ2PyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 11:54:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B874760F9C;
        Fri, 29 Oct 2021 15:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635522698;
        bh=h1cSS8JltbM3YyzLa3nuxhbVdj0z9HevxYcWiaL8O/E=;
        h=From:To:Cc:Subject:Date:From;
        b=QzV9nHfUVh/SB2eJfmFNEjFl2pZLqI9ZwZ7+dExpVe7qZKxu3c75vnShZSeatWSnp
         59DEM0BZtHy54BzXgermuPUTwix04rxkMRO/Q5l7C5FSkBEe5TZCaXHGsHPx5w+Krx
         RMsl+EMffImSApPel68Vg7GpFbsrvXELr1NLK5Ap5P0I/TUWlx3DfIYrWQtXxpj0jG
         XJ3Zvl4ZG644W6K1ow4OPQuEud69n6uf/TuP4hFmKZLzfoFSEgqZS2fohkkSGYKyzJ
         mkq71401r/izrNMzr5/Tt/oKBfGXd7dqYm8SvRxgTU+OKohaZAgzqPrIcp4AWmXYOf
         YmCUIQrRijInw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, willemb@google.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] udp6: allow SO_MARK ctrl msg to affect routing
Date:   Fri, 29 Oct 2021 08:51:33 -0700
Message-Id: <20211029155135.468098-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Looks like SO_MARK from cmsg does not affect routing policy.
This seems accidental.

I opted for net because of the discrepancy between IPv4
and IPv6, but it never worked and doesn't cause crashes..

Jakub Kicinski (2):
  udp6: allow SO_MARK ctrl msg to affect routing
  selftests: udp: test for passing SO_MARK as cmsg

 net/ipv6/udp.c                              |  2 +-
 tools/testing/selftests/net/.gitignore      |  1 +
 tools/testing/selftests/net/Makefile        |  2 +
 tools/testing/selftests/net/cmsg_so_mark.c  | 67 +++++++++++++++++++++
 tools/testing/selftests/net/cmsg_so_mark.sh | 61 +++++++++++++++++++
 5 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/cmsg_so_mark.c
 create mode 100755 tools/testing/selftests/net/cmsg_so_mark.sh


base-commit: 6de6e46d27ef386feecdbea56b3bfd6c3b3bc1f9
-- 
2.31.1

