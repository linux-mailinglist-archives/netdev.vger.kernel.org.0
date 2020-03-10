Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5694517F02A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCJFc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:32:58 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:56792 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgCJFc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:32:58 -0400
Received: from [10.193.177.136] (divyakrishna.asicdesigners.com [10.193.177.136] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02A5WgNi008359;
        Mon, 9 Mar 2020 22:32:43 -0700
Subject: Re: [PATCH net-next v4 1/6] cxgb4/chcr : Register to tls add and del
 callback
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net,
        secdev@chelsio.com, varun@chelsio.com
References: <20200307143608.13109-1-rohitm@chelsio.com>
 <20200307143608.13109-2-rohitm@chelsio.com>
 <20200309160526.26845f55@kicinski-fedora-PC1C0HJN>
 <20200309161021.0e58ee24@kicinski-fedora-PC1C0HJN>
 <20200310023428.GB18504@gondor.apana.org.au>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <b8d68538-a9f2-66a3-411a-ee53d7f7abb2@chelsio.com>
Date:   Tue, 10 Mar 2020 11:02:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200310023428.GB18504@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/03/20 8:04 AM, Herbert Xu wrote:
> On Mon, Mar 09, 2020 at 04:10:21PM -0700, Jakub Kicinski wrote:
>> And the driver lives in drivers/crypto for some inexplicable reason.
> Indeed, and this driver scares me :)
>
> I believe it was added to drivers/crypto because it contained
> code that hooks into the crypto API to provide crypto algorithms.
> At the same time the driver also provides higher-level offload
> directly through the network stack.
>
> The problem with this arrangement is that a lot of network-related
> code gets into the driver with almost no review.
>
> I think it would make much more sense to move the whole driver
> (back) into drivers/net.  There is no reason why it couldn't
> continue to provide crypto API implementations from drivers/net.
>
> Thanks,
Since chtls (inline TOE TLS) was part of drivers/crypto, so I thought of
putting this code there as well. You are right, it makes sense to keep
only chcr co-processor part in drivers/crypto dirctory and shift complete
nic-tls and chtls code in drivers/net directory. We'll work on it ASAP.
