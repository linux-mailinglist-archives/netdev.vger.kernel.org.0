Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14FE30A009
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 02:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhBABdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 20:33:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4261 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhBABdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 20:33:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60175a280001>; Sun, 31 Jan 2021 17:32:24 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 01:32:19 +0000
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        "kernel test robot" <lkp@intel.com>
References: <20210130023319.32560-1-cmi@nvidia.com>
 <20210129225918.0b621ed7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <6ba2203c-919f-7baa-da7e-5c389187ef2a@nvidia.com>
Date:   Mon, 1 Feb 2021 09:32:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129225918.0b621ed7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612143144; bh=s+NoqbsnjQVty+hx2aaRZHJ4VJgeKRTLN2mEzgwu4io=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=Q/J4atC4fGc2Ey7te2MqenH3JCNm8TbfmlRBr/oMy1LaRyD4POxbWbjOasUsx+f2E
         OTmZBVRPKQLQPSFOi327TtBDE0k/78GZHKfZJxoEHb/rhpXRJUTIOhDsZsoYdUSLcV
         fIsHscLngU+oCHUDeShFoAWQEytBuImxJuj4DNtz7NMJLol+xl8mWjztyKDxCNGKp9
         j4JdK6BThEKce0iHAPE4NbdDO0NveDP9hXAJlt5ys7OIGvO4xCmHOLQHHAyC72yfzh
         UYWrzXbWPEO+bfl9LoFLUE+jTUsqVN1KHY1Rhc/7yj3cNwfuzOHbsFNBaGj9Gbsz3v
         0h2bOPaklgzNA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/2021 2:59 PM, Jakub Kicinski wrote:
> On Sat, 30 Jan 2021 10:33:19 +0800 Chris Mi wrote:
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/* Copyright (c) 2021 Mellanox Technologies. */
>> +
>> +const struct psample_ops __rcu *psample_ops __read_mostly;
>> +EXPORT_SYMBOL_GPL(psample_ops);
> Please explain to me how you could possibly have compile tested this
> and not caught that it doesn't build.
Sorry, I don't understand which issue you are talking about. Do you mean
the issue sparse found before or new issues in v5?

Thanks.
