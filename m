Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF06E17F02F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgCJFiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:38:09 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:52909 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgCJFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:38:09 -0400
Received: from [10.193.177.136] (divyakrishna.asicdesigners.com [10.193.177.136] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02A5bu0x008421;
        Mon, 9 Mar 2020 22:37:57 -0700
Subject: Re: [PATCH net-next v4 6/6] cxgb4/chcr: Add ipv6 support and
 statistics
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, secdev@chelsio.com, varun@chelsio.com
References: <20200307143608.13109-1-rohitm@chelsio.com>
 <20200307143608.13109-7-rohitm@chelsio.com>
 <20200309160041.579e1753@kicinski-fedora-PC1C0HJN>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <8ed6d1f1-6d24-6860-55cc-63fe5eaa2b12@chelsio.com>
Date:   Tue, 10 Mar 2020 11:07:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200309160041.579e1753@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/03/20 4:30 AM, Jakub Kicinski wrote:
> On Sat,  7 Mar 2020 20:06:08 +0530 Rohit Maheshwari wrote:
>> - added few necessary stat counters.
> That wasn't the point :/ You were supposed to used ethtool -S like
> everyone else rather than your debugfs files :/

Thanks for pointing it out. I'll add ethtool stat support soon.

