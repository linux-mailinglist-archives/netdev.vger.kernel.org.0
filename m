Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDC66D5DA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbjAQGDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbjAQGDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:03:09 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B78286A5;
        Mon, 16 Jan 2023 22:03:05 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id n8so25155415oih.0;
        Mon, 16 Jan 2023 22:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MRenbNnJ/Lpc9b9yQnu5LykvrxVmObXHzs4NPAu0Krc=;
        b=GLKJhV+lBQ6pogHbslZSC8Q0AASrPnViXmpK/vUUyE5p/hw0LXwo2XyQ6eaebIqeGN
         eHYROmX0jL5hicNzrIF4p1I5DpYQr01O3tUUq76ZQEdfEx3HAtZTErm08rpAyr9fgJzM
         7eHRlA7+IELnou4Ot9R69GCcovH405mO9q+mLPHOWsjb6l7LQnmgWYs9rj63HuObGhnA
         gIYqWRfSfrjtPOn1Nx80MS2YEuRMMOI18rnpEIUh5D2mbwvcn7BS5yoYyWTcz1puIukB
         0nfMaz0uOYvNc2bN33ru6jqAoOjbQz4Gv1OoE4ejazEnsKybSOIahWU6w4wMqcf9svnj
         MUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MRenbNnJ/Lpc9b9yQnu5LykvrxVmObXHzs4NPAu0Krc=;
        b=TIJCjNkBoAhUuTg5Jc5ac0aSBI9G+vXOkta0jZEQrpmzO36sWudys6cpjIY3xWP87w
         A4M5YOun6xpTjNDDjNBTqhX17QtgrA8Q9lMSlFYJqO1gBOTa6amslnwV8wDUCH/TSFzd
         Ck6i6+2Klvf/rtV67EANBQxMXxouCUe3+jno7aV/oA+dl23Oo8+O049Okbe1doFZ5+7g
         84vDyyJ0xnf/s1r3bG1BL1sq4dk8Ai6ER3wmw8zTdKW/GI/GO1IMMh0+ItxeeA2X3lrS
         SkpVO7ksxAL5+sNQ7yuIo7r7EQ+7DKz2laKLb+qvzsXAo/e1iZsohZhbRySEsaYgj+1M
         6krg==
X-Gm-Message-State: AFqh2krXWrKn5BxlbuLPMnueUlYwfy6B8tmnY9/fadmRm1gmwcvXWAD7
        EgPD69cBKuTw144MZh1HE9WTJQoojNM=
X-Google-Smtp-Source: AMrXdXvRPgn4eSULOQi1S1mfD2yPpttIVXUK1ZXs42P2ZhLzV9eD6Igf1s2awc3NchoE6WhKjK15Eg==
X-Received: by 2002:a05:6808:2393:b0:35a:d192:9a53 with SMTP id bp19-20020a056808239300b0035ad1929a53mr1316753oib.41.1673935384677;
        Mon, 16 Jan 2023 22:03:04 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2f2a:7825:8a78:b891])
        by smtp.gmail.com with ESMTPSA id g21-20020a0568080dd500b00360f68d509csm14060974oic.49.2023.01.16.22.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 22:03:03 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next 0/2] bpf: two trivial cleanup patches
Date:   Mon, 16 Jan 2023 22:02:47 -0800
Message-Id: <20230117060249.912679-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains two trivial cleanup patches, please check each
patch for more details.

---
Cong Wang (2):
  bpf: remove a redundant parameter of bpf_map_free_id()
  bpf: remove a redundant parameter of bpf_prog_free_id()

 include/linux/bpf.h  |  4 ++--
 kernel/bpf/offload.c |  4 ++--
 kernel/bpf/syscall.c | 46 ++++++++++----------------------------------
 3 files changed, 14 insertions(+), 40 deletions(-)

-- 
2.34.1

