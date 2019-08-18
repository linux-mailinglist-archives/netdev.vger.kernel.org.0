Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BB919F1
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 00:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfHRWWW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 18 Aug 2019 18:22:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:47077 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfHRWWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Aug 2019 18:22:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Aug 2019 15:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,402,1559545200"; 
   d="scan'208";a="202067407"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2019 15:22:20 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 18 Aug 2019 15:22:20 -0700
Received: from fmsmsx102.amr.corp.intel.com ([169.254.10.170]) by
 FMSMSX109.amr.corp.intel.com ([169.254.15.42]) with mapi id 14.03.0439.000;
 Sun, 18 Aug 2019 15:22:19 -0700
From:   "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "wenwen@cs.uga.edu" <wenwen@cs.uga.edu>,
        linux-wimax <linux-wimax@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] wimax/i2400m: fix a memory leak bug
Thread-Topic: [PATCH v2] wimax/i2400m: fix a memory leak bug
Thread-Index: AQHVU6hH81gCZjl8EkOIBEVs8oU/ZacB4SwA//+eT0o=
Date:   Sun, 18 Aug 2019 22:22:19 +0000
Message-ID: <49AFD2AB-DCA4-470F-96AD-826FAEFDD616@intel.com>
References: <1565900991-3573-1-git-send-email-wenwen@cs.uga.edu>,<20190818.141158.218871786116375619.davem@davemloft.net>
In-Reply-To: <20190818.141158.218871786116375619.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver should be orphaned. 

While I can’t certainly say nobody is using it, the HW has not been sold for years and it hasn’t been brought to current LK standards. 

If your assesment is the code shall not be used, it’s then another argument towards disconnecting it. 

> On Aug 18, 2019, at 14:12, David Miller <davem@davemloft.net> wrote:
> 
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Date: Thu, 15 Aug 2019 15:29:51 -0500
> 
>> In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
>> to hold the original command line options. Then, the options are parsed.
>> However, if an error occurs during the parsing process, 'options_orig' is
>> not deallocated, leading to a memory leak bug. To fix this issue, free
>> 'options_orig' before returning the error.
>> 
>> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> 
> Applied, but... looking at the rest of this file I hope nobody is actually
> running this code.
