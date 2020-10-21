Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEE629479E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407310AbgJUE7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:59:11 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:58090 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407160AbgJUE7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 00:59:11 -0400
Received: from [10.193.177.150] (sony.asicdesigners.com [10.193.177.150] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09L4x24M024622;
        Tue, 20 Oct 2020 21:59:04 -0700
Subject: Re: [PATCH net] chelsio/chtls: Utilizing multiple rxq/txq to process
 requests
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
References: <20201020194305.12352-1-vinay.yadav@chelsio.com>
 <20201020212644.7b25b036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <1485e31a-e248-9b2c-439d-d3e18661669b@chelsio.com>
Date:   Wed, 21 Oct 2020 10:39:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201020212644.7b25b036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/2020 9:56 AM, Jakub Kicinski wrote:
> On Wed, 21 Oct 2020 01:13:06 +0530 Vinay Kumar Yadav wrote:
>> patch adds a logic to utilize multiple queues to process requests.
>> The queue selection logic uses a round-robin distribution technique
>> using a counter.
> 
> What's the Fixes tag for this one?
> 

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")

Thanks,
Vinay
