Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1081E97B5
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgEaMuY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 31 May 2020 08:50:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:25867 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgEaMuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:50:23 -0400
IronPort-SDR: SuV+95/wI0SwbMt4G6aRBUjnlIC0bVLfbAU9XooJ6/FprjV38oV07f1gBOPTMGAPDf3oMjtiTD
 urTSpYBEHNqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:50:23 -0700
IronPort-SDR: Wjfncgyc/GAQ9bO6jO7463ITJ8PsPoVL34BY712BKCJqo2LXkbbn9gA13hsJsRXe9dyo2O8xym
 EMm82gPDBsQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="311712571"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by FMSMGA003.fm.intel.com with ESMTP; 31 May 2020 05:50:23 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 31 May 2020 05:50:22 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.235]) with mapi id 14.03.0439.000;
 Sun, 31 May 2020 05:50:22 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-31
Thread-Topic: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-31
Thread-Index: AQHWN0gXATt5f95czUGQc7yexH/08ajCJQ3Q
Date:   Sun, 31 May 2020 12:50:22 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986E14AD@ORSMSX112.amr.corp.intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Sent: Sunday, May 31, 2020 05:36
> To: davem@davemloft.net
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com
> Subject: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver Updates
> 2020-05-31
> 
> This series contains updates to the ice driver only.
> 
> Brett modifies the driver to allow users to clear a VF's administratively set MAC
> address on the PF.  Fixes the driver to recognize an existing VLAN tag when
> DMAC/SMAC is enabled in a packet.
> Fixes an issue, so that VF's are reset after any VF port VLAN modifications are
> made on the PF.  Made sure the register QRXFLXP_CNTXT is cleared before
> writing a new value to ensure the previous value is not passed forward.
> Updates the PF to allow the VF to request a reset as soon as it has been
> initialized.  Fixes an issue to ensure when a VSI is created, it uses the current
> coalesce value, not the default value.
> 
> Paul allows untrusted VF's to add 16 filters.
> 
> Dan increases the timeout needed after a PFR to allow ample time for package
> download.
> 
> Chinh adjust the define value for the number of PHY speeds we currently
> support.  Changes the driver to ignore EMODE error when configuring the PHY.
> 
> Jesse fixes an issue which was preventing a user from configuring the interface
> before bringing it up.
> 
> Henry fixes the logic for adding back perfect flows after flow director filter does
> a deletion.
> 
> Bruce fixes line wrappings to make it more consistent.

This is my last series of patches, in anticipation of the merge window for net-next closing.
