Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA813B35D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 21:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANUHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 15:07:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:48575 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANUHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 15:07:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 12:07:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,320,1574150400"; 
   d="scan'208";a="256441391"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jan 2020 12:07:46 -0800
Subject: Re: [EXT] [PATCH 11/17] devlink: add a driver-specific file for the
 qed driver
To:     Michal Kalderon <mkalderon@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
 <20200109224625.1470433-12-jacob.e.keller@intel.com>
 <MN2PR18MB3182A8390BC9D7883ED5A18BA1340@MN2PR18MB3182.namprd18.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <a3260b4a-7a72-122a-4661-b1eff74d5c1b@intel.com>
Date:   Tue, 14 Jan 2020 12:07:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <MN2PR18MB3182A8390BC9D7883ED5A18BA1340@MN2PR18MB3182.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/2020 12:41 AM, Michal Kalderon wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>> Sent: Friday, January 10, 2020 12:46 AM
>> +
>> +Parameters
>> +==========
>> +
>> +The ``qed`` driver implements the following driver-specific parameters.
>> +
>> +.. list-table:: Driver-specific parameters implemented
>> +   :widths: 5 5 5 85
>> +
>> +   * - Name
>> +     - Type
>> +     - Mode
>> +     - Description
>> +   * - ``iwarp_cmt``
>> +     - Boolean
>> +     - runtime
>> +     - Enable iWARP functionality for 100g devices. Notee that this impacts
>> +       L2 performance, and is therefor not enabled by default.
> Small typos: Note instead of Notee and therefore instead of therefor
> Other than that looks great, thanks a lot for adding this. 
> 
> Michal
I think this got merged. I'll go ahead and send a follow-up patch to
clean those up. Nice catch!

Regards,
Jake
