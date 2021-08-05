Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77EB3E1D17
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhHET7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:44 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:10795 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhHET7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2021 15:59:43 EDT
Received: (qmail 25992 invoked by uid 89); 5 Aug 2021 19:52:49 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 5 Aug 2021 19:52:49 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 0/6] ptp: ocp: assorted fixes.
Date:   Thu,  5 Aug 2021 12:52:42 -0700
Message-Id: <20210805195248.35665-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assorted fixes for the ocp timecard.

Jonathan Lemon (6):
  ptp: ocp: Fix the error handling path for the class device.
  ptp: ocp: Add the mapping for the external PPS registers.
  ptp: ocp: Remove devlink health and unused parameters.
  ptp: ocp: Use 'gnss' naming instead of 'gps'
  ptp: ocp: Rename version string shown by devlink.
  ptp: ocp: Remove pending_image indicator from devlink

 drivers/ptp/ptp_ocp.c | 153 ++++++++++--------------------------------
 1 file changed, 35 insertions(+), 118 deletions(-)

-- 
2.31.1

