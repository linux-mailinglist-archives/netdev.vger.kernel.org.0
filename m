Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1169042790A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 12:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhJIKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 06:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhJIKj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 06:39:58 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62F6C061570;
        Sat,  9 Oct 2021 03:38:00 -0700 (PDT)
Message-ID: <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1633775877;
        bh=FP4QHWhYPgjbDQ7Gbz/E/+mQlwH5z/kUq6BgWbS1qOg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jDPDHvGlk2IgrAgT8Y+MgQ05kEgdcU9akyg6mMQi4XUuT7HcMREUU55ygXx1BCrza
         aresiwir+C1lhaISjZiNzmTFFXI1G/6UiE+dqauZg6cLzb12+w6MoqNwwJv7+4dRZx
         IYB8+ai09l5W5P3Nl8ev3Is97kAGXSnz+FcdCErG2bzEl8cmGKppEyFL96foXIP+7q
         Ni4Lwtdyjeneewgj62n4a75OYlmOuBuHtB2haCVQYb67neUZBnZHhcjX30t29OrfE4
         4u7zNASHRNMIVUEnAm4vMmTQX8rDqizfWzG3NLkAPRvhjj1yDad1f2UqCaDc0YjHHQ
         hHmT4BkOHwsjg==
Date:   Sat, 9 Oct 2021 12:37:53 +0200
MIME-Version: 1.0
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Content-Language: en-US
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
From:   Nick <vincent@systemli.org>
In-Reply-To: <87czoe61kh.fsf@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/21 10:32, Kalle Valo wrote:

> Nick Hainke <vincent@systemli.org> writes:
>
>> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").
> The fixes tag should be in the end, before Signed-off-by tags. But I can
> fix that during commit.
Thanks for feedback. Already changed that locally but I did not want to 
spam you with another RFC v3. :)
I was able to organize me a BPI-MT7615 PCIE Express Card. With and 
without this patch beacons were sent on the mt7615 pcie, so the patch 
did not make any difference. However, the mt7622 wifi will only work 
with my patch.

OpenWrt buildroot says that the chips are almost the same?

|
> |This adds support for the built-in WMAC on MT7622 SoC devices which 
> has the same feature set as a MT7615, but limited to 2.4 GHz only.||

I also did a version where I check for "is_mt7622(dev)", so it will only 
affect the internal banana pi r64 wifi. I'm happy to insert your 
feedback into my patch.

Bests
Nick

