Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F52731118F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhBESM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:12:28 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:63766 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbhBESKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 13:10:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1612554755; x=1644090755;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=C33Hjg84IH/XVK5SstM96Qg+YYTr2LTi0w27tnHs3Ro=;
  b=PwQsyj5RY1VsBBRXd1IH0Gjy2rwAqttQ2CgTbXfo8icnysGsQmga5T3R
   UuZSQL19xffqRwoUpmfbPCLNrG79Y4p+gS9JXIsqkJa91W50kvNblbUsh
   kpmcnat32fO15b3IvbsOD+ictXz4LTwXUkwpYapFfT6PBXCVflxC1LMDA
   o=;
X-IronPort-AV: E=Sophos;i="5.81,156,1610409600"; 
   d="scan'208";a="116191570"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 Feb 2021 19:51:48 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 84172A1EE7;
        Fri,  5 Feb 2021 19:51:47 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.244) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 5 Feb 2021 19:51:39 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH net V1 0/1] Fix XDP bug in ENA driver
Date:   Fri, 5 Feb 2021 21:51:13 +0200
Message-ID: <20210205195114.10007-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D27UWB003.ant.amazon.com (10.43.161.195) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This single patch fixes a bug spotted in previous XDP Redirect implementation in
ENA.

Shay Agroskin (1):
  net: ena: Update XDP verdict upon failure

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.17.1

