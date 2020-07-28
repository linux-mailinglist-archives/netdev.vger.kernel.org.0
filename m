Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF923100D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgG1QrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:47:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:41219 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731367AbgG1QrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:47:02 -0400
IronPort-SDR: qOp/igNART18hMf8hCQd8AvB8ZXB6rIXt0hehtZz8vJxCOHX+1K2LofWm+FHfG62Hfy8k9cmLg
 hqnLfXzy9gXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="151243340"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="151243340"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 09:47:01 -0700
IronPort-SDR: HOCJ58r9NCmaV92jA5eIdEDKgSCdVuCAJp78Tf1sEEJklyJzOog/+gsyX56U3XbRkor77eKVqv
 ZAvDPYcCIJqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="434382778"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2020 09:47:01 -0700
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-2-git-send-email-moshe@mellanox.com>
 <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200728135808.GC2207@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
Date:   Tue, 28 Jul 2020 09:47:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200728135808.GC2207@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 6:58 AM, Jiri Pirko wrote:
> Tue, Jul 28, 2020 at 02:58:02AM CEST, kuba@kernel.org wrote:
>> On Mon, 27 Jul 2020 14:02:21 +0300 Moshe Shemesh wrote:
>>> Add devlink reload level to allow the user to request a specific reload
>>> level. The level parameter is optional, if not specified then driver's
>>> default reload level is used (backward compatible).
>>
>> Please don't leave space for driver-specific behavior. The OS is
>> supposed to abstract device differences away.
> 
> But this is needed to maintain the existing behaviour which is different
> for different drivers.
> 

Which drivers behave differently here?
