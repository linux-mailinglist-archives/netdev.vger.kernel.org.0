Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0432B197FB9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgC3PfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:35:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26535 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgC3PfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:35:20 -0400
Received: from [10.193.177.147] (lakshmi-pc.asicdesigners.com [10.193.177.147] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02UFYsPM025590;
        Mon, 30 Mar 2020 08:34:54 -0700
Cc:     ayush.sawal@asicdesigners.com,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: linux-next: manual merge of the crypto tree with the net-next
 tree
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20200330114209.1c7d5d11@canb.auug.org.au>
 <20200330004921.GA30111@gondor.apana.org.au>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
Message-ID: <81cc1934-16d1-0553-f280-83ecd097c0ee@chelsio.com>
Date:   Mon, 30 Mar 2020 21:05:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330004921.GA30111@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 3/30/2020 6:19 AM, Herbert Xu wrote:
> On Mon, Mar 30, 2020 at 11:42:09AM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the crypto tree got a conflict in:
>>
>>    drivers/crypto/chelsio/chcr_core.c
>>
>> between commit:
>>
>>    34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
>>
>> from the net-next tree and commit:
>>
>>    53351bb96b6b ("crypto: chelsio/chcr - Fixes a deadlock between rtnl_lock and uld_mutex")
>>
>> from the crypto tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.
> Thanks for the heads up Stephen.
>
> Ayush, I'm going to drop the two chelsio patches.  Going forward,
> please send all chelsio patches via netdev.
Ok, We will using netdev tree for sending all chelsio patches from now on.

Thanks,
Ayush
