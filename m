Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45032156FD
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 02:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfEGAiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 20:38:09 -0400
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:47884 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfEGAiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 20:38:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BRBADz0tBc/5JdJa1lHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBZQKCD4FttCgQhG0CghMjOQUNAQMBAQQBAQIBAm0ohUsGeRBRVwYBgzS?=
 =?us-ascii?q?CC61+hTeDOoFFgTIBhneEVheBf4ERjXYEiweIRpNvCYILVpFnJ26BEQGTUIw?=
 =?us-ascii?q?flRmBZyCBVjMaCBsVggiBIJBwHwOTCgEB?=
X-IronPort-AV: E=Sophos;i="5.60,439,1549929600"; 
   d="scan'208";a="544226930"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 07 May 2019 00:37:45 +0000
Received: from tusi.cisco.com (tusi.cisco.com [172.24.98.27])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTP id x470bjOF019352;
        Tue, 7 May 2019 00:37:45 GMT
From:   Ruslan Babayev <ruslan@babayev.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mika.westerberg@linux.intel.com,
        wsa@the-dreams.de, Andrew Morton <akpm@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH RFC v2 net-next] Enable SFP support on ACPI
Date:   Mon,  6 May 2019 17:35:55 -0700
Message-Id: <20190507003557.40648-1-ruslan@babayev.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505220524.37266-2-ruslan@babayev.com>
References: <20190505220524.37266-2-ruslan@babayev.com>
Reply-To: 20190505220524.37266-2-ruslan@babayev.com
X-Outbound-SMTP-Client: 172.24.98.27, tusi.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Change V2:
- Added more ACPI device details in the commit message.
