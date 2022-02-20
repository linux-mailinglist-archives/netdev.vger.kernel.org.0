Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895EB4BCD9D
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbiBTKEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 05:04:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbiBTKEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 05:04:15 -0500
Received: from mxout01.lancloud.ru (mxout01.lancloud.ru [45.84.86.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6782854692;
        Sun, 20 Feb 2022 02:03:53 -0800 (PST)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 81FA120DA92E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <8e260e34-58aa-53ba-2ad2-164e6462998b@omp.ru>
Date:   Sun, 20 Feb 2022 13:03:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <3d67f0369909010d620bd413c41d11b302eb0ff8.1645342015.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 2/20/22 10:27 AM, Christophe JAILLET wrote:

> 'max_rx_len' can be up to GBETH_RX_BUFF_MAX (i.e. 8192) (see
> 'gbeth_hw_info').
> The default value of 'num_rx_ring' can be BE_RX_RING_SIZE (i.e. 1024).
> 
> So this loop can allocate 8 Mo of memory.

   MB? :-)

> 
> Previous memory allocations in this function already use GFP_KERNEL, so
> use __netdev_alloc_skb() and an explicit GFP_KERNEL instead of a
> implicit GFP_ATOMIC.
> 
> This gives more opportunities of successful allocation.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
