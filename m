Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4231619
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfEaUWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:22:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:45294 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbfEaUWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:22:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 13:22:48 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 31 May 2019 13:22:46 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWo33-000GaT-LT; Sat, 01 Jun 2019 04:22:45 +0800
Date:   Sat, 1 Jun 2019 04:22:23 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH] ptp: ines_ptp_probe_channel() can be static
Message-ID: <20190531202223.GA97559@lkp-kbuild06>
References: <297281011d671dafdced87755fd6e2bd41c6d141.1559281985.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <297281011d671dafdced87755fd6e2bd41c6d141.1559281985.git.richardcochran@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 49268f31cc1f ("ptp: Add a driver for InES time stamping IP core.")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 ptp_ines.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 59cb3f1..52c1e85 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -753,8 +753,8 @@ static u8 tag_to_msgtype(u8 tag)
 	return 0xf;
 }
 
-struct mii_timestamper *ines_ptp_probe_channel(struct device *device,
-					       unsigned int index)
+static struct mii_timestamper *ines_ptp_probe_channel(struct device *device,
+						      unsigned int index)
 {
 	struct device_node *node = device->of_node;
 	struct ines_port *port;
@@ -782,7 +782,7 @@ static void ines_ptp_release_channel(struct device *device,
 {
 }
 
-struct mii_timestamping_ctrl ines_ctrl = {
+static struct mii_timestamping_ctrl ines_ctrl = {
 	.probe_channel = ines_ptp_probe_channel,
 	.release_channel = ines_ptp_release_channel,
 };
