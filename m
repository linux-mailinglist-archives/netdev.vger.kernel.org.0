Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8171CA661
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 10:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEHIo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 04:44:56 -0400
Received: from mx.socionext.com ([202.248.49.38]:6321 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgEHIo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 04:44:56 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 08 May 2020 17:44:54 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id A72DF180139;
        Fri,  8 May 2020 17:44:54 +0900 (JST)
Received: from 172.31.9.53 (172.31.9.53) by m-FILTER with ESMTP; Fri, 8 May 2020 17:44:54 +0900
Received: from yuzu.css.socionext.com (yuzu [172.31.8.45])
        by iyokan.css.socionext.com (Postfix) with ESMTP id 1FB14401DC;
        Fri,  8 May 2020 17:44:54 +0900 (JST)
Received: from [10.213.29.153] (unknown [10.213.29.153])
        by yuzu.css.socionext.com (Postfix) with ESMTP id 95917120136;
        Fri,  8 May 2020 17:44:53 +0900 (JST)
Subject: Re: [PATCH net] dt-bindings: net: Convert UniPhier AVE4 controller to
 json-schema
To:     David Miller <davem@davemloft.net>, robh+dt@kernel.org
Cc:     yamada.masahiro@socionext.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
 <20200501.152130.2290341369746144284.davem@davemloft.net>
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Message-ID: <846aef8c-50b4-e264-9a9e-7d7f25729a94@socionext.com>
Date:   Fri, 8 May 2020 17:44:53 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501.152130.2290341369746144284.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Rob,

On 2020/05/02 7:21, David Miller wrote:
> From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Date: Tue, 28 Apr 2020 15:31:22 +0900
> 
>> Convert the UniPhier AVE4 controller binding to DT schema format.
>> This changes phy-handle property to required.
>>
>> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> 
> DT folks, is it ok if I take this into net-next or do you folks want to
> take it instead?
Rob, how about this?
I think net-next is preferable.

Thank you,

---
Best Regards
Kunihiko Hayashi
