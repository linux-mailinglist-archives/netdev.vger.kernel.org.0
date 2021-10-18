Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7624315AC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhJRKQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbhJRKPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 06:15:38 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED76C061774;
        Mon, 18 Oct 2021 03:13:23 -0700 (PDT)
Message-ID: <f2a5f060-3c25-d22a-3ff5-7c42609df2df@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1634552002;
        bh=9HajkE2qXMxojvnWjEhkynLVQ1MGIixSXKuaxH/TlW4=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=YHmRYOQECm9hi5WaVIyfUX2FMMyGdxPzPsU9bbEMGPSozT1dlzGe/XWLWPBN2ms0v
         ClXbeRviVdXLzaz/WJIu+Mk2z3A78COCG8NQ/j6TKF1qMGYHF2S4PfHS9moFuRwULT
         siOWnwZqR/ekjvfu/FNYIjeHdt9EdZqb+Ode3rKLmZ90ZrRX9dHsOJv8W2YK6y7UiZ
         8AVUfM7Gp80Ygm+GJHTgFTHsAiz0dkk30NycsGjeVs0Lkc9kDxE8s0VFIU3APRtcGS
         ORx0sm1XxU9eAKaPpiCFDj/JlzQDzp30vtt6fNCAj2vMACHstg8yIROrPPc8v+dbmo
         1WsOn8s0fIpGA==
Date:   Mon, 18 Oct 2021 12:13:19 +0200
MIME-Version: 1.0
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Content-Language: en-US
From:   Nick <vincent@systemli.org>
To:     Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
 <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
 <YWGXiExg1uBIFr2c@makrotopia.org>
 <trinity-b64203a5-8e23-4d1c-afd1-a29afa69f8f6-1634473696601@3c-app-gmx-bs33>
 <YWwqlk6rGbEp1obc@makrotopia.org>
 <716d8b51-5a4e-e074-aa1a-4d2055cf18cf@systemli.org>
In-Reply-To: <716d8b51-5a4e-e074-aa1a-4d2055cf18cf@systemli.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I should have added, that the simultanously mode was not working 
on the mt7622 with and without patch. With mt7615e it was working.

Bests
Nick

On 10/18/21 12:11, Nick wrote:
> On 10/17/21 15:52, Daniel Golle wrote:
>
>> Independently of each other or simultanously?
>
> My tests were done simultanously. The "plus" means to the same time 
> with my post. However, simultanously AP and AdHoc was never be 
> possible with the patch, nor without the patch.
>
> Bests
> Nick
>
