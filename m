Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEC54A93BC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 06:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243533AbiBDFyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 00:54:35 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:29835 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiBDFyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 00:54:35 -0500
Received: from [10.193.177.194] (sreekanth.asicdesigners.com [10.193.177.194] (may be forged))
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 2145sJ1A019509;
        Thu, 3 Feb 2022 21:54:22 -0800
Message-ID: <49aeed38-97cc-fce9-64ff-240f84b140b7@chelsio.com>
Date:   Fri, 4 Feb 2022 11:58:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     ayush.sawal@asicdesigners.com, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        secdev@chelsio.com
Subject: Re: [PATCH] MAINTAINERS: Update maintainers for chelsio crypto
 drivers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220203101222.57121-1-ayush.sawal@chelsio.com>
 <20220203134151.140ba81d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
In-Reply-To: <20220203134151.140ba81d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Avast (VPS 220203-22, 2/4/2022), Outbound message
X-Antivirus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/4/2022 3:11 AM, Jakub Kicinski wrote:
> On Thu,  3 Feb 2022 15:42:22 +0530 Ayush Sawal wrote:
>> This updates the maintainer info for chelsio crypto drivers.
>>
>> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> Do you expect us to take this via netdev? You haven't CCed linux-crypto.


Hi Jakub,

Sorry for including the crypto changes here. I will send again a patch 
to netdev which will have the update only for CXGB4 INLINE CRYPTO 
DRIVER. CXGB4 CRYPTO DRIVER (chcr) change I will send to cryptodev.

Thanks,
Ayush


-- 
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

