Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6FE4F8554
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiDGQ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiDGQ5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:57:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FE3237CA
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D54261272
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 16:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA20C385A0;
        Thu,  7 Apr 2022 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649350528;
        bh=lvxLhVsbi1qc5KhqfSBz4TRTZkm74WeGrJ3UBrPY4M4=;
        h=From:To:Cc:Subject:Date:From;
        b=HSaHKteBJltdrUaCjFaFRFy+J4vlTO16g1ovoMIRfkIXExq29hYmWLemJvoFV4XwR
         elmrAvYb+7NiaFb63KNGqwLRmr/nrJdIJrlxCxjBtcUB8Ge5Wdo1XgI7wLZpHqF3Af
         U4cttah/woFtNYrn4iodtIRXSGr1cRdMjYhj/l3ggqdqcZdQhPw7/71kWfo+9aFH7x
         A7Q/RsJblweb0Tph/wUEuskxx6P0/DEbS7PkVcY3muO7C6p1TqFURyg6083Uzcmhsk
         //VmrRcPyb3Out1UNEzryDYJaDo/E3Z8De6gDqROTT7/94zOo5KcnMBrIB+VIGmAqZ
         ROvMpnDc97YsQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [RFC net-next 0/2] Add page_pool_stats ethtool APIs
Date:   Thu,  7 Apr 2022 18:55:03 +0200
Message-Id: <cover.1649350165.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce page_pool_stats support to mvneta driver.

Lorenzo Bianconi (2):
  net: page_pool: introduce ethtool stats
  net: mvneta: add support for page_pool_get_stats

 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 59 ++++++++++++++--
 include/net/page_pool.h               | 24 +++++++
 net/core/page_pool.c                  | 96 +++++++++++++++++++++++++++
 4 files changed, 175 insertions(+), 5 deletions(-)

-- 
2.35.1

