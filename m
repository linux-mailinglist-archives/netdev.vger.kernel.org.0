Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6453226374A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIIU0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:26:09 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:60180 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIIU0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:26:07 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 089KPr6B013006;
        Wed, 9 Sep 2020 13:25:54 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 0/6] chelsio/chtls:Fix inline tls bugs
Date:   Thu, 10 Sep 2020 01:55:34 +0530
Message-Id: <20200909202540.22052-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
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

Sending bug fixes in net-next tree because chtls directory restructure
changes is available only in net-next not in net.

Thanks,
Vinay

Vinay Kumar Yadav (6):
  chelsio/chtls:Fix socket lock
  chelsio/chtls: correct netdevice for vlan interface
  chelsio/chtls:Fix panic when server is on ipv6
  chelsio/chtls: Fix panic when listen on multiadapter
  chelsio/chtls: correct function return and return type
  chelsio/chtls: Fix writing freed memory

 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 19 +++++++++++++------
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  5 +++--
 2 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.18.1

