Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3780F3603AE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDOHsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:48:46 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:34223 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOHsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:48:45 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13F7mBlv023347;
        Thu, 15 Apr 2021 00:48:12 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net 0/4] chelsio/ch_ktls: chelsio inline tls driver bug fixes
Date:   Thu, 15 Apr 2021 13:17:44 +0530
Message-Id: <20210415074748.421098-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches fix following bugs in Chelsio inline tls driver.
Patch1: kernel panic.
Patch2: connection close issue.
Patch3: tcb close call issue.
Patch4: unnecessary snd_una update.

Vinay Kumar Yadav (4):
  ch_ktls: Fix kernel panic
  ch_ktls: fix device connection close
  ch_ktls: tcb close causes tls connection failure
  ch_ktls: do not send snd_una update to TCB in middle

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 102 ++----------------
 1 file changed, 11 insertions(+), 91 deletions(-)

-- 
2.30.2

