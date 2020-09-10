Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C020F2651D4
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgIJVC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:02:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:36376 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgIJVCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:02:40 -0400
IronPort-SDR: kgNxVg35zYEmD6cO/44VhgzwPH0yeopu+YigEw41b4hxVvfYZ8kWOLJy9wdZeA81a5RwNelRZm
 eHzKgcnBs7zQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="138659600"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="138659600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:02:37 -0700
IronPort-SDR: KPp0v91ipiBdXW8U+UXR9WHKSRukXTOtiGLg7/8jpj+PUKC/o/CsaAgkG++3Nrn5j6n0u+BW5H
 GYpZGf4mxT0A==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="505969056"
Received: from pojenhsi-mobl1.amr.corp.intel.com (HELO [10.252.128.198]) ([10.252.128.198])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:02:37 -0700
Subject: Re: [net-next v4 4/5] devlink: add support for overwrite mask to
 netdevsim
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
 <20200909222653.32994-5-jacob.e.keller@intel.com>
 <20200909180540.50c88522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <eddcade5-3b63-45f0-f8e9-68f075b1fe63@intel.com>
Date:   Thu, 10 Sep 2020 14:02:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909180540.50c88522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 6:05 PM, Jakub Kicinski wrote:
> On Wed,  9 Sep 2020 15:26:52 -0700 Jacob Keller wrote:
>> The devlink interface recently gained support for a new "overwrite mask"
>> parameter that allows specifying how various sub-sections of a flash
>> component are modified when updating.
>>
>> Add support for this to netdevsim, to enable easily testing the
>> interface. Make the allowed overwrite mask values controllable via
>> a debugfs parameter. This enables testing a flow where the driver
>> rejects an unsupportable overwrite mask.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> nit: subject should be prefixed with netdevsim: not devlink:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 

Yep. when I split the patch apart, I had copied and edited the commit
message but forgot to change the subject.
