Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67EC426014
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhJGW5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhJGW5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 18:57:00 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84ADC061570;
        Thu,  7 Oct 2021 15:55:05 -0700 (PDT)
Message-ID: <9de61dcc-cf6e-aeed-a077-756b697fb534@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1633647302;
        bh=e4EzXYaT64uH4mIE+8y/VnHFOhPneiui80T0S65fW+s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cxHuFn3uc0Nvx6xxmiT+pzHunfl5EblnogR2cqRVVzVVgS+JAD7kzkwmhdS2c3/19
         +G0+bzqWFSEqE16ro2C6BvIm0VXufwPaaflTk9sXq6qdrgLvjpxftaBl+fCT051N8/
         R/OdXtzRWctDzvtmuF+vcs0MrrkEZpNmHZ4fVE/mfD12VvwtI0qK7C+ybzQCWEdvDG
         TthE2CELJ3tDXa/QtGk/GVTKySXHWyQzGwcEWqGnVfOL831qLOnMdkzUHJamZD/fau
         8AYW76QyHKAQxVZZofAG3jqxu73qlRUHh8vyjQ3gyDEuq4FiTDDiv7p9xQC18r32bW
         Gj8zccSxfzeEQ==
Date:   Fri, 8 Oct 2021 00:54:57 +0200
MIME-Version: 1.0
Subject: Re: [RFC v1] mt76: mt7615: mt7622: fix adhoc and ibss mode
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
References: <20211007212323.1223602-1-vincent@systemli.org>
 <YV92Wjo+3dZ49DL6@makrotopia.org>
From:   Nick <vincent@systemli.org>
In-Reply-To: <YV92Wjo+3dZ49DL6@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/8/21 00:36, Daniel Golle wrote:
> On Thu, Oct 07, 2021 at 11:23:23PM +0200, Nick Hainke wrote:
>> Subject: [RFC v1] mt76: mt7615: mt7622: fix adhoc and ibss mode
> Ad-Hoc and IBSS mode are synonyms.
> What probably meant to write 'fix adhoc and mesh mode', right?
>
Yes. Or maybe even better "fix adhoc and meshpoint'. :)
I will update.

Bests
Nick
