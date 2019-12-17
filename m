Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047B9122CEA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfLQNcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:32:36 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59273 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576589555; x=1608125555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=onLQnvSBL3lNxDnDN4WMJbsPXtOY8gXICW/wG+jHVxA=;
  b=Wbpn/zVSeGDIxNJVGP8raHdYBFEoI4EIkq+OZcGkgFd0nj34JfFyNU+u
   xloKxE3rS7dmvUaC3ZrCo5WffEHrjOcRGERRFwWJYgWLabJwjwFa7NAtO
   pUgMZv/1HzxOxHMmv/mmcLig/VPO//6R6z10e+DebpNFzYjpsj7IWqzsd
   Q=;
IronPort-SDR: wLNC9ZIehASY3f9dI/UiaPPmHOoqvQqvhd83w4KLqwpCJJU/JxA54jXs6vLnq7tEwgK7u4xP8w
 vLdHImIkxGbg==
X-IronPort-AV: E=Sophos;i="5.69,325,1571702400"; 
   d="scan'208";a="15379886"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 17 Dec 2019 13:32:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 4C13FA16A1;
        Tue, 17 Dec 2019 13:32:24 +0000 (UTC)
Received: from EX13D32EUC001.ant.amazon.com (10.43.164.159) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 13:32:23 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D32EUC001.ant.amazon.com (10.43.164.159) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 13:32:22 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 17 Dec 2019 13:32:20 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>
Subject: [PATCH net-next 0/3] xen-netback: clean-up
Date:   Tue, 17 Dec 2019 13:32:15 +0000
Message-ID: <20191217133218.27085-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Durrant (3):
  xen-netback: move netback_probe() and netback_remove() to the end...
  xen-netback: switch state to InitWait at the end of netback_probe()...
  xen-netback: remove 'hotplug-status' once it has served its purpose

 drivers/net/xen-netback/xenbus.c | 350 +++++++++++++++----------------
 1 file changed, 171 insertions(+), 179 deletions(-)

-- 
2.20.1

