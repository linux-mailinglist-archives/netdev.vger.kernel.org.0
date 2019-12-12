Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FB411C65A
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 08:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfLLHZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 02:25:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:21658 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbfLLHZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 02:25:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 23:25:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,305,1571727600"; 
   d="scan'208";a="245598700"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 11 Dec 2019 23:25:20 -0800
Received: from [10.226.38.237] (unknown [10.226.38.237])
        by linux.intel.com (Postfix) with ESMTP id 4F11058033E;
        Wed, 11 Dec 2019 23:25:18 -0800 (PST)
Subject: Re: [PATCH v2] staging: intel-gwdpa: gswip: Introduce Gigabit
 Ethernet Switch (GSWIP) device driver
To:     dan.carpenter@oracle.com
References: <5f85180573a3fb20238d6a340cdd990f140ed6f0.1576054234.git.jack.ping.chng@intel.com>
 <20191211105757.GC2070@kadam>
 <BYAPR11MB3176EB0A2BF59AAF161D4174DE5A0@BYAPR11MB3176.namprd11.prod.outlook.com>
From:   "Chng, Jack Ping" <jack.ping.chng@linux.intel.com>
Cc:     devel@driverdev.osuosl.org, cheol.yong.kim@intel.com,
        andriy.shevchenko@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mallikarjunax.reddy@linux.intel.com,
        gregkh@linuxfoundation.org, davem@davemloft.net
Message-ID: <b46dc709-38c7-9c6e-cb75-e5efd3be6ae9@linux.intel.com>
Date:   Thu, 12 Dec 2019 15:25:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BYAPR11MB3176EB0A2BF59AAF161D4174DE5A0@BYAPR11MB3176.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On 11/12/2019 6:58 PM, Dan Carpenter wrote:

> This should just be sent to netdev.  I spotted a couple bugs.
>
> 1) enable/disable we flipped xgmac_set_xgmii_2500_speed()
> 2) retries wasn't reset in a couple places.
>
> I had a few tiny style nits as well but there is no reason to send it to
> staging.
>
> regards,
> dan carpenter

Thanks for the review and comments.
We will fix the bug and address the comments.

Best regards,
Chng Jack Ping

