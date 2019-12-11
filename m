Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5A11B4A0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387437AbfLKPsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:48:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36189 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732172AbfLKPsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so7500029wma.1;
        Wed, 11 Dec 2019 07:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HHknGkOCqrNxt52GD3cXj52e9zxxPE4soKJv+dpWQEY=;
        b=oIWbnlROfjQnCGNZCiLi7byhz4dLIGt+RjME0td4t9fKjpw4v5g8O/0dvwvittn8mJ
         OPWZGZg0MRyuKXLf2j0MSrvmubrpM8RKFSQ1lrFFMEgmFK5B0c7/sq01c37gMAGBO/s/
         fKveW0mw9IYp9hdK0rZL/rjPTErRkyurTlsGRBY0I4FdsweH4ug1HiP9KaCSH27mt+Ei
         IG1jsaAyCz28knZ5rBagaJFKi1S7MA1A+ZzO1z9IEUnlCwMQ+yYpiirPQ0wOTqBDzFQX
         i/2kZNvbB0fMsdevMZX2DTSSnvum286LBzIzuR2js0juXe1/2jYqQcRHyhwlB24GdgYL
         PiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HHknGkOCqrNxt52GD3cXj52e9zxxPE4soKJv+dpWQEY=;
        b=LHLLx++r8YHXbDmQhEYVO68NSMDlCF50AxP2fUjYGKNBf3KtqVnyn41zwqrTM/3WZN
         3Od93RJqQy1EdLmthBNhbPOm2ixvftO1bKfUinECpDJ3czLmyyiBLgFH8v6tYLw/6kNW
         wAES4P+UjeqPlGA4sAlAKuXg3hfvm0lSiLQFVPewqOFFhv0ceHfyU+t79j57uMD180K2
         9XJg9UZrUkdj6RYuID65C2toqoh7dPzOdbh5N9fI0JK3X5qnOsTREs+vebX31MA2KUy3
         zY2ol/F2zhjYAt9MMyLdrKcmdL9BuDqNkeC/VDhecJWPSjYbL32pLWjyKMf37efx02au
         yZFA==
X-Gm-Message-State: APjAAAUkgJncltgCRFb0SQzNyfjgxjkCbeWJg7zFB+kGKC0uYBYqE/R3
        XU4ZxpCh3uThfHQE5OWp6Vk=
X-Google-Smtp-Source: APXvYqwkGklybJhQUkvyxLGUfCYJKgd1v5Gr+omfdMAso88OSlk52wgRnLzLQ9dxxh8rIc7M5DJJmg==
X-Received: by 2002:a7b:c151:: with SMTP id z17mr461367wmi.137.1576079311277;
        Wed, 11 Dec 2019 07:48:31 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:30 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 0/6] rtlwifi: convert rtl8192{ce,cu,de} to use generic functions
Date:   Wed, 11 Dec 2019 16:47:49 +0100
Message-Id: <20191211154755.15012-1-straube.linux@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the drivers rtl8192{ce,cu,de} to use the generic
functions rtl_query_rxpwrpercentage and rtl_signal_scale_mapping.

Michael Straube (6):
  rtlwifi: rtl8192ce: use generic rtl_query_rxpwrpercentage
  rtlwifi: rtl8192cu: use generic rtl_query_rxpwrpercentage
  rtlwifi: rtl8192de: use generic rtl_query_rxpwrpercentage
  rtlwifi: rtl8192ce: use generic rtl_signal_scale_mapping
  rtlwifi: rtl8192cu: use generic rtl_signal_scale_mapping
  rtlwifi: rtl8192de: use generic rtl_signal_scale_mapping

 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 48 ++----------------
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  | 49 ++-----------------
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 47 ++----------------
 3 files changed, 14 insertions(+), 130 deletions(-)

-- 
2.24.0

