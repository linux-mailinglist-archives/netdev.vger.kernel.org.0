Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C55166A57
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 23:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgBTW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 17:26:50 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45477 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgBTW0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 17:26:49 -0500
Received: by mail-pg1-f195.google.com with SMTP id b9so2616094pgk.12
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 14:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xPbcILrYGGDS/0jB/HHKSeDTV7zuNCVqzmFmPOkEsgM=;
        b=QKKxe0cQMnskZqToR0T6nmiM+rjMjZuSifkv/k5Nc2hxzIHrB7Dy+KYn1IxhgWNtCe
         RdAR2jirpxIF2fMMKZLLW5fENUYo0z5dXw+j4S5f+4MgG5xcde86U1Npi5c0WW8n8LjA
         u/Pdk34sDeY82dkjAOHt92q/hVsjF8fVUBU3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xPbcILrYGGDS/0jB/HHKSeDTV7zuNCVqzmFmPOkEsgM=;
        b=nkxg/twk9Lj/K6JkfU0k/zWswSmG6EANNMjwxfh/3G056GvFDN1j15FIl57AvuIHvX
         8UCwcGCi9aFeK2ynVeHRlaOM5jPmDh1pRoLnc8FzK9qVC1pWe7GIX+vHOh4/pwtJMrkl
         Fv4e5FfbRimGUSxEEHZVw81S/jqg8149IU299yKF0vVZ0oZlxja0KZrkgr8R6dEsLdXJ
         jW+ee8D9BPYVxwA9c22TckpevpZkMiQdVBShKbUOrBo/ntk5zJNByE3dWHoNUPjPg/VN
         oe+UTBFF0OoxaMmNaQJZtNo9+/DufWtLCMar8jtrVrYnmB5rB44VgwsTBpQZOEd8vQ4b
         9Xbg==
X-Gm-Message-State: APjAAAUoW/xiSsLUIT7H6NEJyB06ziayGEBs5enBxS+BARBbKRAKeC6R
        48shxMlBpU5QLEA0/25TJt3Mt0QArmg=
X-Google-Smtp-Source: APXvYqyXubo6EKHeIEM/QHAvjxMNjclymsEUEsExrFhagpkOEh1RT/4zvv/pgVBB5b32LDfh1m03oA==
X-Received: by 2002:a63:bc02:: with SMTP id q2mr34134719pge.174.1582237608979;
        Thu, 20 Feb 2020 14:26:48 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c26sm607831pfj.8.2020.02.20.14.26.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:26:48 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/2] bnxt_en: shutdown and kexec/kdump related fixes.
Date:   Thu, 20 Feb 2020 17:26:33 -0500
Message-Id: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 small patches to fix kexec shutdown and kdump kernel driver init issues.

Please also queue these for -stable.  Thanks.

Vasundhara Volam (2):
  bnxt_en: Improve device shutdown method.
  bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.5.1

