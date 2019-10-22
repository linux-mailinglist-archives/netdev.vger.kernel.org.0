Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7745DE0892
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfJVQTj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 12:19:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:30068 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730331AbfJVQTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 12:19:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 09:19:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,216,1569308400"; 
   d="scan'208";a="197166132"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga007.fm.intel.com with ESMTP; 22 Oct 2019 09:19:38 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 22 Oct 2019 09:19:38 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.88]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.185]) with mapi id 14.03.0439.000;
 Tue, 22 Oct 2019 09:19:38 -0700
From:   "Allan, Bruce W" <bruce.w.allan@intel.com>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: RE: [net-next v3 2/5] e1000e: Add support for S0ix
Thread-Topic: [net-next v3 2/5] e1000e: Add support for S0ix
Thread-Index: AQHViDn8atIXCJaa1kmdBZ4YVy3ZGqdmzRcQ
Date:   Tue, 22 Oct 2019 16:19:37 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1840109952313@ORSMSX121.amr.corp.intel.com>
References: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
 <20191021180143.11775-3-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20191021180143.11775-3-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTZmMmI3OWMtYTQ5MC00NGViLTkxMjQtN2MzYjFhNmZhM2E2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQllLUFpVVE5CZzlXZDR3Rm5keUpHUVwvczhaMHBaMHdNbWV0WGdtWHROUzUwR2xZNEExRGxsSDRzbDRpN2pyV1gifQ==
x-ctpclassification: CTP_NT
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
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Jeff Kirsher
> Sent: Monday, October 21, 2019 11:02 AM
> To: davem@davemloft.net
> Cc: Neftin, Sasha <sasha.neftin@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Wysocki, Rafael J
> <rafael.j.wysocki@intel.com>; Lifshits, Vitaly <vitaly.lifshits@intel.com>;
> Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>; Brown, Aaron F
> <aaron.f.brown@intel.com>; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Subject: [net-next v3 2/5] e1000e: Add support for S0ix
> 
> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> Implement flow for S0ix support. Modern SoCs support S0ix low power
> states during idle periods, which are sub-states of ACPI S0 that increase
> power saving while supporting an instant-on experience for providing
> lower latency that ACPI S0. The S0ix states shut off parts of the SoC
> when they are not in use, while still maintaning optimal performance.
> This patch add support for S0ix started from an Ice Lake platform.
> 
> Suggested-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
> Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
> Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 182 +++++++++++++++++++++
>  drivers/net/ethernet/intel/e1000e/regs.h   |   4 +
>  2 files changed, 186 insertions(+)

This patch generates warnings that e1000e_s0ix_entry_flow and e1000e_s0ix_exit_flow
are defined but not used [-Wunused-function] when CONFIG_PM_SLEEP is not defined.

The warnings were called out by Intel's 0-DAY kernel test infrastructure after this patch
was merged into the dev-queue branch of Jeff's next-queue tree, so any fix for the warnings
should include the tag " Reported-by: kbuild test robot <lkp@intel.com>".

Bruce.
