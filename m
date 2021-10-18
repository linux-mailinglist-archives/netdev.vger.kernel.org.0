Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0D4314A4
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhJRKOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhJRKON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 06:14:13 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECD8C06161C;
        Mon, 18 Oct 2021 03:12:01 -0700 (PDT)
Message-ID: <716d8b51-5a4e-e074-aa1a-4d2055cf18cf@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1634551917;
        bh=8UJIhyN70fwZRjgdbrYqAOMY3Pk75xYpYaIPzb8qPwY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=4ILAevtORG94wHNj5SUdRup29o7pulKiaN9XdfX0kPxDFwx8wwk2Q0sUrC81o5X8n
         BniEkZmSOHqppsjttcNBQunAHX6ayJcMlXVSUYy3AE2GZhFZg5khfESeE9mDKj0nT2
         eOEC4KyTrXg1DPFBLbEuGMP0Nz8YEAMS2s5LFxgkOvT/OipSgEMyyRs+lPeE+fNd3h
         iQ8I5GIy9rM4GyhF3QH1+UaUqPw2Xzq1pwDowIiOsVJx67bbNJ6+70eNHLbB78HyEu
         GiUWj/VTnwGwV31xZGAOmvcL3wuT1RNUAdC7te1lCBqBbWmGDtBYocf0+M090xEltm
         +id8fSc8R34jg==
Date:   Mon, 18 Oct 2021 12:11:54 +0200
MIME-Version: 1.0
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Content-Language: en-US
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
From:   Nick <vincent@systemli.org>
In-Reply-To: <YWwqlk6rGbEp1obc@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/21 15:52, Daniel Golle wrote:

> Independently of each other or simultanously?

My tests were done simultanously. The "plus" means to the same time with 
my post. However, simultanously AP and AdHoc was never be possible with 
the patch, nor without the patch.

Bests
Nick

