Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2D2F7050
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbhAOCCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:02:40 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:1504 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbhAOCCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:02:40 -0500
Received: from [10.193.177.176] (raina-lt.asicdesigners.com [10.193.177.176] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10F21bAD031184;
        Thu, 14 Jan 2021 18:01:39 -0800
Cc:     ayush.sawal@asicdesigners.com, netdev@vger.kernel.org,
        davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] ch_ipsec: Remove initialization of rxq related data
To:     Jakub Kicinski <kuba@kernel.org>
References: <20210113044302.25522-1-ayush.sawal@chelsio.com>
 <20210114104235.00a87c1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
Message-ID: <20379fe5-1287-bdf5-bb27-fcc5c119287b@chelsio.com>
Date:   Fri, 15 Jan 2021 07:46:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210114104235.00a87c1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 1/15/2021 12:12 AM, Jakub Kicinski wrote:
> On Wed, 13 Jan 2021 10:13:02 +0530 Ayush Sawal wrote:
>> Removing initialization of nrxq and rxq_size in uld_info. As
>> ipsec uses nic queues only, there is no need to create uld
>> rx queues for ipsec.
> Why is this a fix? Does it break something or just wastes resources?
> If it's just about efficient use of resources I'll apply to net-next.

yes this patch is about efficient use of resources, please apply it to 
net-next.

Thanks,
Ayush

