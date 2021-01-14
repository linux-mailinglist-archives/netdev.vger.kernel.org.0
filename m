Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2142F6EB9
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbhANW46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:56:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:64839 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbhANW46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:56:58 -0500
IronPort-SDR: JVHsbuO2nc8aIrUoXhoPCXDULYyXx5n1HVKdZhcJG+mlylwMjNjgWG83ejgpEyAtKJ70EIfWY/
 LXagan2tsI4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="174951517"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="174951517"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 14:56:18 -0800
IronPort-SDR: 9slGu/3z6covVU3S8QdsYGEvRS3dri0wYbDaVvfiH77lU6gxXCPVUW9Q8VNfI/CaFFYZvvm6kR
 rSpmgIkK4+nQ==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="354072068"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.116.186]) ([10.254.116.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 14:56:17 -0800
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com
References: <20210113121222.733517-1-jiri@resnulli.us>
 <X/+nVtRrC2lconET@lunn.ch> <20210114073948.GJ3565223@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <35d85fb0-a3db-e0c4-ca5a-f3e962c3dfbf@intel.com>
Date:   Thu, 14 Jan 2021 14:56:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114073948.GJ3565223@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2021 11:39 PM, Jiri Pirko wrote:
> Thu, Jan 14, 2021 at 03:07:18AM CET, andrew@lunn.ch wrote:
>>
>> I assume if i prevision for card4ports but actually install a
>> card2ports, all the interfaces stay down?
> 
> Yes, the card won't get activated in case or provision mismatch.
> 

If you're able to detect the line card type when plugging it in, I don't
understand why you need system administrator to pre-provision it using
such an interface? Wouldn't it make more sense to simply detect the
case? Or is it that you expect these things to be moved around and want
to make sure that you can configure the associated netdevices before the
card is plugged in?
