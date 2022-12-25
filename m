Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7902D655E47
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 22:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLYVCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 16:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLYVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 16:02:00 -0500
X-Greylist: delayed 552 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 25 Dec 2022 13:01:55 PST
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4185F2DF1;
        Sun, 25 Dec 2022 13:01:54 -0800 (PST)
Received: from x2100.. (unknown [IPv6:2607:f598:b99a:480:2da1:ebcf:44f5:35ad])
        by cavan.codon.org.uk (Postfix) with ESMTPSA id A1A3040918;
        Sun, 25 Dec 2022 20:52:37 +0000 (GMT)
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     johan@kernel.org, bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Add some USB hotspot IDs
Date:   Sun, 25 Dec 2022 12:52:21 -0800
Message-Id: <20221225205224.270787-1-mjg59@srcf.ucam.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: *
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a few additional IDs to support a couple of hotspots I had lying around.


