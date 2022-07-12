Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BFC57195A
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 14:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiGLMB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 08:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiGLMBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 08:01:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D79D11F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 05:01:24 -0700 (PDT)
From:   Benedikt Spranger <b.spranger@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1657627281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LIBRNfzbZ1AFc6BGdnmOP94Tece5203U1VdsaBhyAdI=;
        b=GVGbL0tAicDoNosvsSXq2HvLb3aLOZ3DlhO6KEmTNMW/Jc2TMqYaS23y2ztreEsxmZuTpr
        HNQRJIssBFtKFHDSB0v5nPm02rFEkPOrSsBPq1IjiHW+tuoJTNWtmuW6F9GaJgR5nNq2W5
        30j5oeuHIDZwTEbgFkt+akeyTuXabjpD0NAoBULL45vLL9I5Cp9CcS1WDIaGScU+5Ickwd
        4WQw7UYLo7L4QFixJ5OyFfyTdYarWMwowFtMSFs3Xqnkv6OwMqQG1zDaQH6BLnhqCga48n
        1wcQleznzUm22U/pJLpG8CLzu0My2YoU1bds7pIeaEolGaALedRvXSrZXmn7kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1657627281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LIBRNfzbZ1AFc6BGdnmOP94Tece5203U1VdsaBhyAdI=;
        b=foXM/WKqLTTGQXUAjoZZwvHoRdmTuiCg3q1Mi3BYBbGpINrk1Z85pf85t/qu+8Rf7CxigY
        cQ/WY4mIMR6RDsAw==
To:     netdev@vger.kernel.org
Subject: [PATCH ethtool 0/1] Add pretty printer for CPSW ALE table
Date:   Tue, 12 Jul 2022 14:01:13 +0200
Message-Id: <20220712120114.3219-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

the TI CPSW switch family expose the ALE table entries by ethtool
register dump. Add a pretty printer to decode the ALE entries in a
nice human readable way.

Regards
    Bene Spranger

Benedikt Spranger (1):
  pretty: Add support for TI CPSW register dumps

 Makefile.am |   2 +-
 cpsw.c      | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 ethtool.c   |   1 +
 internal.h  |   3 +
 4 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100644 cpsw.c

-- 
2.36.1

