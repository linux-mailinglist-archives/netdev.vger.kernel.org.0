Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE1D613902
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiJaOc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiJaOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:32:57 -0400
Received: from mail.draketalley.com (mail.draketalley.com [3.213.214.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66E7F5AD;
        Mon, 31 Oct 2022 07:32:55 -0700 (PDT)
Received: from pop-os.lan (cpe-74-72-139-32.nyc.res.rr.com [74.72.139.32])
        by mail.draketalley.com (Postfix) with ESMTPSA id 030D355DBF;
        Mon, 31 Oct 2022 14:25:29 +0000 (UTC)
From:   drake@draketalley.com
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev
Cc:     linux-kernel@vger.kernel.org, Drake Talley <drake@drake.talley.com>
Subject: [PATCH 0/3] cleanup style for staging qlge driver
Date:   Mon, 31 Oct 2022 10:25:13 -0400
Message-Id: <20221031142516.266704-1-drake@draketalley.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,SPF_HELO_SOFTFAIL,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Drake Talley <drake@drake.talley.com>

This patch series addresses a handful of reports from checkpatch from qlge_main.c


Thanks,
Drake

Drake Talley (3):
  staging: qlge: Separate multiple assignments
  staging: qlge: replace msleep with usleep_range
  staging: qlge: add comment explaining memory barrier

 drivers/staging/qlge/qlge_main.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

-- 
2.34.1

