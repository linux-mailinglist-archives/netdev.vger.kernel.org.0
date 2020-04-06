Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD99819FD5D
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgDFSnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:43:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:39853 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDFSnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 14:43:52 -0400
IronPort-SDR: oddSB75mCaBIvjPn3CZMewYRwXbuyc0TnonX9RTpxOj+RZAlUj2rxUj7tpSk1Gvmt+jFZoxy6s
 oA9le/wiwiCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 11:43:51 -0700
IronPort-SDR: Kp0fm1DLjj4pO2dIp4jtJ4gZwLlXphary7K2GdTjOJ1qKBEgYK0YklxhfpGdntQHK6FwVDd7EW
 UHAtOKLTOoEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="239703307"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.233.77]) ([10.212.233.77])
  by orsmga007.jf.intel.com with ESMTP; 06 Apr 2020 11:43:50 -0700
Subject: Re: [patch iproute2/net-next] devlink: fix JSON output of mon command
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, mlxsw@mellanox.com
References: <20200402095608.18704-1-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <6c15c9ec-e1e3-cf78-e2bb-9c5db8d43abc@intel.com>
Date:   Mon, 6 Apr 2020 11:43:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402095608.18704-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/2020 2:56 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> The current JSON output of mon command is broken. Fix it and make sure
> that the output is a valid JSON. Also, handle SIGINT gracefully to allow
> to end the JSON properly.
> 

I wonder if there is an easy way we could get "make check" or something
to add a test to help verify this is valid JSON?

Thanks,
Jake
