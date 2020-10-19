Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE6A2926AC
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgJSLu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:50:59 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:42255 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJSLu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:50:59 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09JBoo1d003914;
        Mon, 19 Oct 2020 04:50:50 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 0/6] chelsio/chtls: Fix inline tls bugs
Date:   Mon, 19 Oct 2020 17:20:19 +0530
Message-Id: <20201019115025.24233-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches fix following bugs in chelsio inline tls driver.

Patch1: Fix incorrect socket lock.
Patch2: correct netdevice for vlan interface.
Patch3: Fix panic when server is listening on ipv6.
Patch4: Fix panic when listen on multiadapter.
Patch5: correct function return and return type.
Patch6: Fix writing freed memory.

Thanks,
Vinay

Vinay Kumar Yadav (6):
  chelsio/chtls: fix socket lock
  chelsio/chtls: correct netdevice for vlan interface
  chelsio/chtls: fix panic when server is on ipv6
  chelsio/chtls: Fix panic when listen on multiadapter
  chelsio/chtls: correct function return and return type
  chelsio/chtls: fix writing freed memory

 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 19 +++++++++++++------
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  5 +++--
 2 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.18.1

