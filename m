Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3C712E9DA
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgABSWy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 13:22:54 -0500
Received: from mga18.intel.com ([134.134.136.126]:2931 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgABSWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 13:22:54 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 10:22:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="270381105"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jan 2020 10:22:53 -0800
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jan 2020 10:22:53 -0800
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.94]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.12]) with mapi id 14.03.0439.000;
 Thu, 2 Jan 2020 10:22:52 -0800
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
CC:     David Miller <davem@davemloft.net>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH] drivers/net/b44: Change to non-atomic bit operations
Thread-Topic: [PATCH] drivers/net/b44: Change to non-atomic bit operations
Thread-Index: AQHVt4u4RnJ8wHjyUkiWRBJZ56DwGKfKiKsAgAAOgACAAUJyAIAL6e1Q
Date:   Thu, 2 Jan 2020 18:22:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7F515CBB@ORSMSX115.amr.corp.intel.com>
References: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
        <20191224.161826.37676943451935844.davem@davemloft.net>
        <20191225011020.GE241295@romley-ivt3.sc.intel.com>
 <20191225122424.5bc18036@hermes.lan>
In-Reply-To: <20191225122424.5bc18036@hermes.lan>
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

> Why not just make pwol_pattern aligned and choose the right word to do
> the operation on?

We use that approach for places where the operation needs to be atomic.

But this one doesn't need an atomic operation since there can be no other
entity operating on the same bitmap in parallel.

-Tony
