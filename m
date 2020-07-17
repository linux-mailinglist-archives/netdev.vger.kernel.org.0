Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251462233B9
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgGQGYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:39 -0400
Received: from mx58.baidu.com ([61.135.168.58]:33153 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727837AbgGQGYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:35 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 30E892040056;
        Fri, 17 Jul 2020 14:24:22 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com
Subject: [PATCH 0/2] intel/xdp fixes for fliping rx buffer 
Date:   Fri, 17 Jul 2020 14:24:20 +0800
Message-Id: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes ice/i40e/ixgbe/ixgbevf_rx_buffer_flip in
copy mode xdp that can lead to data corruption.

I split two patches, since i40e/xgbe/ixgbevf supports xsk
receiving from 4.18, put their fixes in a patch 

Li RongQing (2):
  xdp: i40e: ixgbe: ixgbevf: not flip rx buffer for copy mode xdp
  ice/xdp: not adjust rx buffer for copy mode xdp

 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 5 ++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c         | 5 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 5 ++++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 5 ++++-
 include/net/xdp.h                                 | 3 +++
 net/xdp/xsk.c                                     | 4 +++-
 6 files changed, 22 insertions(+), 5 deletions(-)

-- 
2.16.2

