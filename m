Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A1464B10
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 10:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbhLAJ6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 04:58:47 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47729 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232736AbhLAJ6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 04:58:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uz06wY5_1638352522;
Received: from 30.240.100.124(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uz06wY5_1638352522)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 01 Dec 2021 17:55:24 +0800
Message-ID: <31dd5d45-d6cc-1074-ff55-e989f67e1016@linux.alibaba.com>
Date:   Wed, 1 Dec 2021 17:55:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] net/tls: Fix authentication failure in CCM mode
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org
References: <20211129093212.4053-1-tianjia.zhang@linux.alibaba.com>
 <e623a691-2212-e1cc-7fed-1c3a2043b6bd@novek.ru>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <e623a691-2212-e1cc-7fed-1c3a2043b6bd@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

On 11/30/21 6:39 AM, Vadim Fedorenko wrote:
> On 29.11.2021 09:32, Tianjia Zhang wrote:
>> When the TLS cipher suite uses CCM mode, including AES CCM and
>> SM4 CCM, the first byte of the B0 block is flags, and the real
>> IV starts from the second byte. The XOR operation of the IV and
>> rec_seq should be skip this byte, that is, add the iv_offset.
>>
>> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Nice catch, thanks!
> This is what I was talking about last time.
> 
> Tested-by: Vadim Fedorenko <vfedorenko@novek.ru>

David has applied this patch, the tested tag may not be added, still 
thanks for your test.

Kind regards,
Tianjia
