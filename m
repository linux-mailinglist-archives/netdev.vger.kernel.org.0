Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5D85897E1
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 08:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiHDGt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 02:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiHDGt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 02:49:27 -0400
X-Greylist: delayed 541 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Aug 2022 23:49:24 PDT
Received: from hannover.ccc.de (ep.leitstelle511.net [80.147.51.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63C3A485
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 23:49:24 -0700 (PDT)
Date:   Thu, 4 Aug 2022 08:40:20 +0200
From:   Ingo Saitz <ingo@hannover.ccc.de>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Documentation fix
Message-ID: <Yutp1LUTDrpGprhL@pinguin.zoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_40,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

The wangxun ethernet driver contains a confusing kernel config
description: (in drivers/net/ethernet/wangxun/Kconfig)

..."to skip all
    the questions about Intel cards."

This clearly should read Wangxun, not Intel, I assume.

    Ingo
-- 
Kennedy's Lemma:
    If you can parse Perl, you can solve the Halting Problem.

http://www.perlmonks.org/?node_id=663393
