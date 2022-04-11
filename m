Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C74FBAE1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbiDKL3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbiDKL3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:29:20 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BF3E38DAD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:27:07 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 88990320259;
        Mon, 11 Apr 2022 12:27:05 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1ndsCH-0004ai-11; Mon, 11 Apr 2022 12:27:05 +0100
Subject: [PATCH net-next 0/3] sfc: Remove some global definitions
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 11 Apr 2022 12:27:04 +0100
Message-ID: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are some small cleanups to remove definitions that need not
be defined in .h files.
---

Martin Habets (3):
      sfc: efx_default_channel_type APIs can be static
      sfc: Remove duplicate definition of efx_xmit_done
      sfc: Remove global definition of efx_reset_type_names


 drivers/net/ethernet/sfc/efx.h          |    1 -
 drivers/net/ethernet/sfc/efx_channels.c |   52 +++++++++++++++++--------------
 drivers/net/ethernet/sfc/efx_channels.h |    4 --
 drivers/net/ethernet/sfc/efx_common.c   |    4 +-
 drivers/net/ethernet/sfc/farch.c        |    1 +
 drivers/net/ethernet/sfc/net_driver.h   |    5 ---
 6 files changed, 31 insertions(+), 36 deletions(-)

--
Martin Habets <habetsm.xilinx@gmail.com>
