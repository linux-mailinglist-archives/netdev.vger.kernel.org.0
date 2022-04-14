Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88C350092A
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241400AbiDNJE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241590AbiDNJCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:02:40 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B423422292;
        Thu, 14 Apr 2022 02:00:13 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.31:43882.1165221160
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.43 (unknown [10.64.8.31])
        by 189.cn (HERMES) with SMTP id 97FC1100226;
        Thu, 14 Apr 2022 17:00:11 +0800 (CST)
Received: from  ([123.150.8.43])
        by gateway-153622-dep-749df8664c-cv9r2 with ESMTP id 74a86b6b571a4cd2ac806d568bb29da3 for ast@kernel.org;
        Thu, 14 Apr 2022 17:00:12 CST
X-Transaction-ID: 74a86b6b571a4cd2ac806d568bb29da3
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.43
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From:   Song Chen <chensong_2000@189.cn>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Song Chen <chensong_2000@189.cn>
Subject: [RFC PATCH 0/1] sample: bpf: introduce irqlat
Date:   Thu, 14 Apr 2022 17:07:20 +0800
Message-Id: <1649927240-18991-1-git-send-email-chensong_2000@189.cn>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm planning to implement a couple of ebpf tools for preempt rt,
including irq latency, preempt latency and so on, how does it sound
to you?

Song Chen (1):
  sample: bpf: introduce irqlat

 samples/bpf/.gitignore    |   1 +
 samples/bpf/Makefile      |   5 ++
 samples/bpf/irqlat_kern.c |  81 ++++++++++++++++++++++++++++++
 samples/bpf/irqlat_user.c | 100 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 187 insertions(+)
 create mode 100644 samples/bpf/irqlat_kern.c
 create mode 100644 samples/bpf/irqlat_user.c

-- 
2.25.1

