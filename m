Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59698142AC
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 00:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfEEWHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 18:07:08 -0400
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:28484 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEEWHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 18:07:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AMCQDJXc9c/4wNJK1lHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBZQKCD4E6ATKyK4F6EIRtgggjOgQNAQMBAQQBAQIBAm0ohj8LgT4BgzS?=
 =?us-ascii?q?CC6sfiGOBRYEyAYZ3hFYXgX+BEYJkixIEk0mTaQmCC1aRYydugRABk0mMG5U?=
 =?us-ascii?q?RgWkLE4FWMxoIGxWDKJBwHwORbwEB?=
X-IronPort-AV: E=Sophos;i="5.60,435,1549929600"; 
   d="scan'208";a="554054908"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 05 May 2019 22:07:06 +0000
Received: from tusi.cisco.com (tusi.cisco.com [172.24.98.27])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTP id x45M76ds003095;
        Sun, 5 May 2019 22:07:06 GMT
From:   Ruslan Babayev <ruslan@babayev.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mika.westerberg@linux.intel.com,
        wsa@the-dreams.de, Andrew Morton <akpm@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Enable SFP driver on ACPI based systems
Date:   Sun,  5 May 2019 15:05:21 -0700
Message-Id: <20190505220524.37266-1-ruslan@babayev.com>
X-Mailer: git-send-email 2.17.1
X-Outbound-SMTP-Client: 172.24.98.27, tusi.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have split the patch and resending to all relevant mailing lists as
requested by Heiner Kallweit.


[PATCH net-next 1/2] i2c: acpi: export
[PATCH net-next 2/2] net: phy: sfp: enable i2c-bus detection on ACPI

