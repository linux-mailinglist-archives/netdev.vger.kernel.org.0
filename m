Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A17F10866
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfEANrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:47:21 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:21453 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfEANrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556718440; x=1588254440;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=X8BQBTBxSozr2UXfoDcbZIqiD5JJU4bJ1pE3G+jJKW8=;
  b=OMh3lVh00g7auyOofWnKSSer9kQsn4i/3FOnjRMxdRxRU53q6y5nbXU7
   y4fI3mqNqOkrGOEi+5eBw2DAz4b+kkro27j4jXuCYFmEbn+1aUc7kHWRL
   Ti511KyiXYlyX4GiirFxHz2XOrceNO8qL5L+yY5nm4v6ctLI5BwhvGE7T
   c=;
X-IronPort-AV: E=Sophos;i="5.60,417,1549929600"; 
   d="scan'208";a="802298956"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 May 2019 13:47:19 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x41DlFEa112010
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 May 2019 13:47:18 GMT
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:17 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 1 May 2019 13:47:13 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net 0/8] Bug fixes for ENA Ethernet driver
Date:   Wed, 1 May 2019 16:47:02 +0300
Message-ID: <20190501134710.8938-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Sameeh Jubran (8):
  net: ena: fix swapped parameters when calling
    ena_com_indirect_table_fill_entry
  net: ena: fix: set freed objects to NULL to avoid failing future
    allocations
  net: ena: fix: Free napi resources when ena_up() fails
  net: ena: fix incorrect test of supported hash function
  net: ena: fix return value of ena_com_config_llq_info()
  net: ena: improve latency by disabling adaptive interrupt moderation
    by default
  net: ena: fix ena_com_fill_hash_function() implementation
  net: ena: gcc 8: fix compilation warning

 drivers/net/ethernet/amazon/ena/ena_com.c     | 11 ++++++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  4 +--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 28 +++++++++++--------
 3 files changed, 27 insertions(+), 16 deletions(-)

-- 
2.17.1

