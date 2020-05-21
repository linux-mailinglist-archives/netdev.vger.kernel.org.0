Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971D61DC5B7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 05:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgEUDj1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 23:39:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:63628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbgEUDj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 23:39:27 -0400
IronPort-SDR: IV+DyGh3Li6pUAI8i8f9+hSgG5Afk3XXiZpkQSVCiibTf8gASIDsqH6F8QfYmT8xfe4SGf97I+
 dcs1o2g2su1g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 20:39:26 -0700
IronPort-SDR: MHhWqZBzxyCbSVWPIhvr903BELA5m92ECx+A7EyB7CtVdwLmnPk8oegefjdwsgAz0OiazBgEoW
 DeB1/NO1Gzyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,416,1583222400"; 
   d="scan'208";a="268488068"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2020 20:39:26 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.75]) with mapi id 14.03.0439.000;
 Wed, 20 May 2020 20:39:26 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
Thread-Topic: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
 Updates 2020-05-19
Thread-Index: AQHWLjo4zxakhy/5jEi2QtFU4xpWyaiyR+kA//+d/PA=
Date:   Thu, 21 May 2020 03:39:26 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986C8744@ORSMSX112.amr.corp.intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
 <20200520.192828.1242706969153634308.davem@davemloft.net>
In-Reply-To: <20200520.192828.1242706969153634308.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, May 20, 2020 19:28
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com
> Subject: Re: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver
> Updates 2020-05-19
> 
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Tue, 19 May 2020 17:04:05 -0700
> 
> > This series contains updates to igc only.
> >
> > Sasha cleans up the igc driver code that is not used or needed.
> >
> > Vitaly cleans up driver code that was used to support Virtualization
> > on a device that is not supported by igc, so remove the dead code.
> >
> > Andre renames a few macros to align with register and field names
> > described in the data sheet.  Also adds the VLAN Priority Queue Fliter
> > and EType Queue Filter registers to the list of registers dumped by
> > igc_get_regs().  Added additional debug messages and updated return
> > codes for unsupported features.  Refactored the VLAN priority
> > filtering code to move the core logic into igc_main.c.  Cleaned up
> > duplicate code and useless code.
> >
> > The following are changes since commit
> 2de499258659823b3c7207c5bda089c822b67d69:
> >   Merge branch 's390-next'
> > and are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
> > 1GbE
> 
> Pulled, thanks Jeff.
[Kirsher, Jeffrey T] 

Thanks, have you been able to push you tree to kernel.org yet?
