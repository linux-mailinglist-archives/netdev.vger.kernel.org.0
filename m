Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362112F1C42
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389458AbhAKRYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:24:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:14832 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389196AbhAKRYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 12:24:44 -0500
IronPort-SDR: 7sFMj3pON/IWwN0a7CN5gdqqjaj8kp+xEDmQQRESaFUf4OD9SB7F/VFtLsrB27o6aBMicWcfsP
 +2xmL5u5I6yA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="174391959"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="174391959"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 09:24:03 -0800
IronPort-SDR: ZzE6wAc8X4j0vb0vRJbpG/9Ykuww8aQnCAFNjUaIw12l5TxnCe+iv7gnSkADl8/v3pEGsD0QMZ
 Hb5J0OSSJDMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="464227154"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 11 Jan 2021 09:24:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Jan 2021 09:24:03 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Jan 2021 09:24:02 -0800
Received: from fmsmsx611.amr.corp.intel.com ([10.18.126.91]) by
 fmsmsx611.amr.corp.intel.com ([10.18.126.91]) with mapi id 15.01.1713.004;
 Mon, 11 Jan 2021 09:24:02 -0800
From:   "Kleen, Andi" <andi.kleen@intel.com>
To:     Robert Buhren <robert.buhren@sect.tu-berlin.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Radev, Martin" <martin.radev@aisec.fraunhofer.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "doshir@vmware.com" <doshir@vmware.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Morbitzer, Mathias" <mathias.morbitzer@aisec.fraunhofer.de>,
        "file@sect.tu-berlin.de" <file@sect.tu-berlin.de>,
        "Banse, Christian" <christian.banse@aisec.fraunhofer.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: RE: Security issue with vmxnet3 and e100 for AMD SEV(-SNP) / Intel
 TDX
Thread-Topic: Security issue with vmxnet3 and e100 for AMD SEV(-SNP) / Intel
 TDX
Thread-Index: AQHW6B1Sq0leUKGYv0+6SEmL25DAQaoi+P8A//+zpdA=
Date:   Mon, 11 Jan 2021 17:24:02 +0000
Message-ID: <719473c603774460970f93d926530b87@intel.com>
References: <AM7P194MB0900E443CEBD6EF2EE37325ED9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
 <AM7P194MB09004AD790C5C85EDCB42323D9AE0@AM7P194MB0900.EURP194.PROD.OUTLOOK.COM>
 <20210111132602.bcd5hmtoqe4dcjwp@black.fi.intel.com>
 <749d3ace-877f-1c5c-bb00-ffcb8394f36a@sect.tu-berlin.de>
In-Reply-To: <749d3ace-877f-1c5c-bb00-ffcb8394f36a@sect.tu-berlin.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PkxldCB1cyBrbm93IGlmIHlvdSBhcmUgaW50ZXJlc3RlZCBpbiBvdXIgZnV6emluZy9zdGF0aWMg
YW5hbHlzaXMgc2V0dXAuDQo+V2UncmUgcGxhbm5pbmcgdG8gc3VibWl0IGEgcGFwZXIgc29vbiBh
bmQgd2Ugd2lsbCBwdWJsaXNoIHRoZSBzb3VyY2UgPmNvZGUgYWxvbmcgd2l0aCB0aGUgcGFwZXIu
DQoNCldlIGFscmVhZHkgaGF2ZSBhbiBvd24gc3RhdGljIGFuYWx5c2lzL2Z1enppbmcgZnJhbWUg
d29yaywgYnV0IGl0J3Mgbm90IHJlbGVhc2VkIHlldC4NCg0KLUFuZGkNCg0KDQo=
