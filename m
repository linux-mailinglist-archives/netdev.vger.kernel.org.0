Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66C1EB99D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 12:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgFBK3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 06:29:11 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:4676 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgFBK3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 06:29:11 -0400
Received: from [10.193.177.142] (arunbr.asicdesigners.com [10.193.177.142] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 052ASwl5031236;
        Tue, 2 Jun 2020 03:28:59 -0700
Cc:     ayush.sawal@asicdesigners.com, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
References: <20200602091249.66601c4c@canb.auug.org.au>
 <8a8bc5f4-2dc3-5e2c-3013-51954004594c@chelsio.com>
 <20200602201821.615b9b7b@canb.auug.org.au>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
Message-ID: <9aff949b-6a03-ae7c-33ee-bb9e4bb01fae@chelsio.com>
Date:   Tue, 2 Jun 2020 16:00:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602201821.615b9b7b@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/2/2020 3:48 PM, Stephen Rothwell wrote:
> Hi Ayush,
>
> On Tue, 2 Jun 2020 13:01:09 +0530 Ayush Sawal <ayush.sawal@chelsio.com> wrote:
>> On 6/2/2020 4:42 AM, Stephen Rothwell wrote:
>>> In commit
>>>
>>>     055be6865dea ("Crypto/chcr: Fixes a coccinile check error")
>>>
>>> Fixes tag
>>>
>>>     Fixes: 567be3a5d227 ("crypto:
>>>
>>> has these problem(s):
>>>
>>>     - Subject has leading but no trailing parentheses
>>>     - Subject has leading but no trailing quotes
>>>
>>> Please do not split Fixes tags over more than one line.
>> I am so sorry for this mistake.
>> Is there a way to fix this?
> No, David does not rebase his tree.  Just remember for next time.

Okay , i will keep this in mind. Thanks.


