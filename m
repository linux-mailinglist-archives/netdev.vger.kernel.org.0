Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A1261310A
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 08:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJaHI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 03:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiJaHIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 03:08:25 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA562C2
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 00:08:21 -0700 (PDT)
X-QQ-mid: bizesmtp69t1667200096to91h720
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 31 Oct 2022 15:08:08 +0800 (CST)
X-QQ-SSF: 01400000000000M0L000000A0000000
X-QQ-FEAT: TVZM0Uoyj00f4gbKLUdN1yUj1JR3QDeMKnvTSwRm1qd4TAI8hIi/SV784PEiN
        Q3XyB4Hck1lgFtQEahcgEKxwrRW5+jPRnWOintem2KEfC9AvWKLhC/iHq3oeD6uAkT9/y2o
        Ai77e3e2unVKDyDaPQztTg48NGzrCCrcCgbRN9Y/aTCnhp4kWC5SPKELnULziXJDeYzQcmK
        aqLEORPOlJn+9swBkSM7XEvO8FIcji7VWE7hPv9LcvFXmrOJvGROJ6yDSe7heIpvdEgwes4
        XSwgw+qfZbNsHkAGLbUqvn+NdTXniB1XHB8HxE8dbrMIOv1DXfsHQHdLxOLaFSkw5MVL5j6
        25BiuvI0dEopqrKiy95bIZ3vpsI6NTJFVNdG41W4C1QLVoUgiuStVaLnDF+czuSdyONm5I1
        WBF4lo2BZEE=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 0/3] net: WangXun txgbe/ngbe ethernet driver
Date:   Mon, 31 Oct 2022 15:07:54 +0800
Message-Id: <20221031070757.982-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for WangXun NICS, to initialize
interface from software to firmware.

Jiawen Wu (2):
  net: libwx: Implement interaction with firmware
  net: txgbe: Add operations to interact with firmware

Mengyuan Lou (1):
  net: ngbe: Initialize sw info and register netdev

 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 463 ++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  10 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 115 +++++
 drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  55 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  87 ++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |  12 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 368 ++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  99 +++-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 219 ++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   2 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  85 +++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  14 +
 15 files changed, 1522 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h

-- 
2.38.1

