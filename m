Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235C8D3466
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfJJXfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:35:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57564 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJJXfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DlXH4R1S1cfQrztVA5sQ9h7XdZJZOKDB2yAQ1wGqpSk=; b=Jc4YagVmqbUh99KDHoBhPLO03
        5E6mFta3c6b/ZFB6sFsaxHNlpUXd4tJK/nROTWRwHym1gbG04Om8i70JsBD/xN5rLtE0c+KOTtFpT
        uSgMtpi332nMheNsLo0QDXL0kmm/Tz56tgqSIB2nIgLFUpjJnKtWtlOLHHCKKa46WM5ErdVUo+bxW
        hKLBl4awMS4nphMojG8cHSyR2VG4AIIDE1SREcQ1ywy8nLPniQDVF2bZW+RTQxTZu1QcdwGlxYs9Q
        KkPKEHvznFzDQnay2wVQyyPwK26Dvmczo9LqqvXRiZrl6AeUw+Kf/Ds6JFZewdQir/zv14eplCnS6
        gN5LYt6tQ==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIhxU-0003rA-JV; Thu, 10 Oct 2019 23:35:00 +0000
Subject: Re: [PATCH] Documentation: networking: add a chapter for the DIM
 library
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        David Miller <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
References: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
 <20191010162003.4f36a820@cakuba.netronome.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4c7f5563-2ca1-d37b-7639-f3df99a0219b@infradead.org>
Date:   Thu, 10 Oct 2019 16:34:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191010162003.4f36a820@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/19 4:20 PM, Jakub Kicinski wrote:
> On Thu, 10 Oct 2019 15:55:15 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Add a Documentation networking chapter for the DIM library.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Tal Gilboa <talgi@mellanox.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-rdma@vger.kernel.org
>> ---
>>  Documentation/networking/index.rst   |    1 +
>>  Documentation/networking/lib-dim.rst |    6 ++++++
>>  2 files changed, 7 insertions(+)
>>
>> --- linux-next-20191010.orig/Documentation/networking/index.rst
>> +++ linux-next-20191010/Documentation/networking/index.rst
>> @@ -33,6 +33,7 @@ Contents:
>>     scaling
>>     tls
>>     tls-offload
>> +   lib-dim
>>  
>>  .. only::  subproject and html
>>  
>> --- /dev/null
>> +++ linux-next-20191010/Documentation/networking/lib-dim.rst
>> @@ -0,0 +1,6 @@
>> +=====================================================
>> +Dynamic Interrupt Moderation (DIM) library interfaces
>> +=====================================================
>> +
>> +.. kernel-doc:: include/linux/dim.h
>> +    :internal:
>>
>>
> 
> CC: linux-doc, Jake
> 
> How does this relate to Documentation/networking/net_dim.txt ?
> (note in case you want to edit that one there is a patch with 
> updates for that file from Jake I'll be applying shortly)
> 

There is also a small patch from Jesse:
https://lore.kernel.org/netdev/20191010193112.15215-1-jesse.brandeburg@intel.com/


-- 
~Randy
