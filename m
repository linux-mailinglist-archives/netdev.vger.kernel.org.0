Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DAF150C56
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 17:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgBCQfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 11:35:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:28871 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgBCQfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 08:35:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278794352"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 08:35:19 -0800
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-9-jacob.e.keller@intel.com>
 <20200131100723.0d6893fa@cakuba.hsd1.ca.comcast.net>
 <78e85b70-41f3-d2fa-1227-dea732dea116@intel.com>
 <20200201094302.7b6ed97a@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <336730c0-797c-a695-ba63-b4a9033477ee@intel.com>
Date:   Mon, 3 Feb 2020 08:35:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200201094302.7b6ed97a@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/2020 9:43 AM, Jakub Kicinski wrote:
> On Fri, 31 Jan 2020 16:51:10 -0800, Jacob Keller wrote:
>> TL;DR; Yes, I'd like to have a single devlink for the device, but no, I
>> don't have a good answer for how to do it sanely.
> 
> Ack, it not a new problem and I don't have a solution either :(
> 

Right.

> I don't think mlx5 has this distinction of only single/first PF being
> able to perform device-wide updates so perhaps it's better to not
> introduce that notion? 
> 

I was just talking about that with someone yesterday. Yea, I think
you're right. I believe both the overall devlink mutex and the device's
NVM acquire locking mechanism should be suitable to prevent access.

I was originally just trying to make it difficult to somehow start
updates or perform conflicting activity over multiple PFs at once.

Thanks,
Jake
