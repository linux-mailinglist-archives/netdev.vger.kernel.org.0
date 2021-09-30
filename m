Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6F41D1E1
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347916AbhI3DgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:36:25 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:39219 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347601AbhI3DgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:36:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uq59mav_1632972878;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uq59mav_1632972878)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Sep 2021 11:34:39 +0800
Subject: Re: [PATCH] net/tls: support SM4 CCM algorithm
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210928062843.75283-1-tianjia.zhang@linux.alibaba.com>
 <1761d06d-0958-7872-04de-cde6ddf8a948@novek.ru>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <1195374a-a9d4-0431-015b-60d986e29881@linux.alibaba.com>
Date:   Thu, 30 Sep 2021 11:34:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1761d06d-0958-7872-04de-cde6ddf8a948@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

On 9/29/21 5:24 AM, Vadim Fedorenko wrote:
> On 28.09.2021 07:28, Tianjia Zhang wrote:
>> The IV of CCM mode has special requirements, this patch supports CCM
>> mode of SM4 algorithm.
>>
> Have you tried to connect this implementation to application with
> user-space implementation of CCM mode? I wonder just because I have an
> issue with AES-CCM Kernel TLS implementation when it's connected to
> OpenSSL-driven server, but still have no time to fix it correctly.

I did not encounter any issue when using KTLS with AES-CCM algorithm, 
but the KTLS RX mode on the OpenSSL side does not seem to be supported.

I encountered some problems when using the SM4-CCM algorithm of KTLS. 
Follow the RFC8998 specification, the handshake has been successful, and 
the first data transmission can be successful. After that, I will 
encounter the problem of MAC verification failure, but this is issue on 
the OpenSSL side. because the problem is still being investigated, I 
have not opened the code for the time being.

Cheers,
Tianjia
