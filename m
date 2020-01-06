Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBF5131861
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 20:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAFTMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 14:12:05 -0500
Received: from mxout2.idt.com ([157.165.5.26]:43372 "EHLO mxout2.idt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgAFTMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 14:12:05 -0500
Received: from mail6.idt.com (localhost [127.0.0.1])
        by mxout2.idt.com (8.14.4/8.14.4) with ESMTP id 006JC0b6019762;
        Mon, 6 Jan 2020 11:12:00 -0800
Received: from corpml3.corp.idt.com (corpml3.corp.idt.com [157.165.140.25])
        by mail6.idt.com (8.14.4/8.14.4) with ESMTP id 006JC0IW029465;
        Mon, 6 Jan 2020 11:12:00 -0800
Received: from vcheng-VirtualBox.na.ads.idt.com (corpimss2.corp.idt.com [157.165.141.30])
        by corpml3.corp.idt.com (8.11.7p1+Sun/8.11.7) with ESMTP id 006JBxW23349;
        Mon, 6 Jan 2020 11:12:00 -0800 (PST)
From:   vincent.cheng.xh@renesas.com
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 net-next 0/1] Replace IDT with Renesas and improve version info.
Date:   Mon,  6 Jan 2020 14:11:48 -0500
Message-Id: <1578337909-4700-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Replacing IDT with Renesas patches has been withdrawn.
This series reworks the version info displayed for the clockmatrix chip.

Apologize for the delayed response to Dec 20 feedback.
Corporate email server hiccup so email was not received.
Added more details to Patch 1/1 commit message to explain the change.

Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")

Changes since v2:
- Add details to commit message for Patch 1 to provide
  background information.

Changes since v1:
- Remove Patch 1/3 Add Replace idt with renesas in dt-bindings
- Remove Patch 2/3 Replaces IDT references with Renesas
- Patch 3/3 becomes patch 1/1

Vincent Cheng (1):
  ptp: clockmatrix: Rework clockmatrix version information.

 drivers/ptp/ptp_clockmatrix.c | 77 ++++++++-----------------------------------
 1 file changed, 13 insertions(+), 64 deletions(-)

-- 
2.7.4

