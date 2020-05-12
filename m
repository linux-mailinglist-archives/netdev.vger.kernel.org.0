Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFBF1CEAB4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 04:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgELCSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 22:18:40 -0400
Received: from mx.socionext.com ([202.248.49.38]:44388 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgELCSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 22:18:39 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 12 May 2020 11:18:38 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id 4E8B9180BB6;
        Tue, 12 May 2020 11:18:38 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Tue, 12 May 2020 11:18:38 +0900
Received: from yuzu.css.socionext.com (yuzu [172.31.8.45])
        by kinkan.css.socionext.com (Postfix) with ESMTP id EDACE1A01BB;
        Tue, 12 May 2020 11:18:37 +0900 (JST)
Received: from [10.213.31.213] (unknown [10.213.31.213])
        by yuzu.css.socionext.com (Postfix) with ESMTP id 67C7D120133;
        Tue, 12 May 2020 11:18:37 +0900 (JST)
Subject: Re: [PATCH net] dt-bindings: net: Convert UniPhier AVE4 controller to
 json-schema
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
 <20200512020126.GA22178@bogus>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <600b83e2-8063-b8ca-5406-7bf854c45ab3@socionext.com>
Date:   Tue, 12 May 2020 11:18:36 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512020126.GA22178@bogus>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 2020/05/12 11:01, Rob Herring wrote:
> On Tue, Apr 28, 2020 at 03:31:22PM +0900, Kunihiko Hayashi wrote:
>> Convert the UniPhier AVE4 controller binding to DT schema format.
>> This changes phy-handle property to required.
>>
>> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>> ---

(snip)

>> +  phy-mode:
>> +    $ref: ethernet-controller.yaml#/properties/phy-mode
>> +
>> +  phy-handle:
>> +    $ref: ethernet-controller.yaml#/properties/phy-handle
> 
> No need for these $ref, the 1st reference did this. Just:
> 
> phy-mode: true

Okay, "phy-handle" also replaces with "true".
I'll fix it in v2.

Thank you,
  
---
Best Regards
Kunihiko Hayashi
