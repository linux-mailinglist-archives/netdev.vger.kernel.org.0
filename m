Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF3820DFB8
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389568AbgF2UjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731724AbgF2TOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:15 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C690C0A8884;
        Mon, 29 Jun 2020 00:26:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id c1so384101pja.5;
        Mon, 29 Jun 2020 00:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYJKmE7yRo1ixIz8HpJIKtPVneklCF0ayYZCHIK8EeE=;
        b=ETUdifcZaxHgQ48Wde9ZIvalgHRr2IpHQLLiZnWHytAq24TQ8K7zASRVrF/+skVFqn
         RKlKDVZkTI8ZndVkU4DtGQdNSA/BgX4OjdoC4bH9ACkvNJn49fDp7fwLatM1xLWxK7bE
         +W5+Pb3Vvtlsh5ZuB1W+gN2cnZc0HrLFU2+1Xc13CDA14a19fcbXdz3sBiLikw5PhSt5
         x+ah6FfNTa9hRJkIBleZu2Rl1eD5ZE6pEqMU3Zjm0GBgWzAeoHtZzf9SFMr9pXRId/dG
         VKnZmRR0yJGFOc4F0BEuxTdI7I58coK4BOSc4QHoHu7baAKr+2QP9qscaIPVxo7ynAev
         B/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYJKmE7yRo1ixIz8HpJIKtPVneklCF0ayYZCHIK8EeE=;
        b=Dwh6sGrHYcdT5MV+Lmxz9hGu840fiG9X1RCfL2tvQ8ma0x4JNifMTSnFpU/Mr44EMK
         um6VBNC8BEakORCO1ixnjSDHWvLkub43sSyhuwa5SKDAjprAMj0MF/8haWEajk4yVJJl
         AUut8wrnO4EqcDcjBf5l6j+UbFSFoqp2GDn1FPvKvFAiTNmsbkhC2kPTk0Y2wwqoY+WL
         OI/TLwBJPqphPaQCPYWOcH0edptjO6KliFaGKPp5sch4AWdVQBxKp2UzQqAPFpD3FEj+
         lLsEaUHVxl0Sh4oWYNbBT5l0sh9CEr1QBagMSS3NWG5vaygwUWdFhsx8Nu6+4j4/LDZ3
         /xbg==
X-Gm-Message-State: AOAM532xjudPrj2wIoEqhgW2lki7KT8NMuCsLJmJ+fLi7/yL4xEIW9w+
        eKpun0HnHhJYZhoRqPz2A+s=
X-Google-Smtp-Source: ABdhPJw7/Ns0hjjDKLsAKA2XwfV4jnOl/CKEE+c4gdUObP9BqDcFYIDHPoFLlO72Kc3GEdrw8wp7Mw==
X-Received: by 2002:a17:902:710d:: with SMTP id a13mr11960415pll.71.1593415609467;
        Mon, 29 Jun 2020 00:26:49 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id q10sm34637627pfk.86.2020.06.29.00.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 00:26:48 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: [PATCH v1 0/2] ipw2x00: use generic power management
Date:   Mon, 29 Jun 2020 12:55:23 +0530
Message-Id: <20200629072525.156154-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from amd ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (2):
  ipw2100: use generic power management
  ipw2200: use generic power management

 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 31 +++++---------------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 30 +++++--------------
 2 files changed, 14 insertions(+), 47 deletions(-)

-- 
2.27.0

