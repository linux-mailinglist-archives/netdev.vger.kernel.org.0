Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA29282AAC
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 14:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgJDMqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 08:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbgJDMqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 08:46:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D3D5206C1;
        Sun,  4 Oct 2020 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601815569;
        bh=KmlOPDI70o6oZU+d45F/jzuxfUWYoVayUg2hJ7fdtXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5zXzEeVvnzVMH3HoN78Ppoz9GCrFs1Ea5iwlpRkhjj4Z8EntXyUUzszRNs0F6CGt
         wbUCUCsqOuijVE61LGLlJNdh/cuBaJaMYcBkOstJS/n5tVCx9wauqY6ZoWr5AXqfFN
         qtQEwDVD5415kNqCC3hxEARHAFTkhJ9DC7g3UFpM=
Date:   Sun, 4 Oct 2020 08:46:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.8 08/29] net: dsa: microchip: look for phy-mode
 in port nodes
Message-ID: <20201004124608.GJ2415204@sasha-vm>
References: <20200929013027.2406344-1-sashal@kernel.org>
 <20200929013027.2406344-8-sashal@kernel.org>
 <20200929055630.GA9320@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200929055630.GA9320@laureti-dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 07:56:30AM +0200, Helmut Grohne wrote:
>Hi Sascha,
>
>On Tue, Sep 29, 2020 at 03:30:05AM +0200, Sasha Levin wrote:
>> From: Helmut Grohne <helmut.grohne@intenta.de>
>>
>> [ Upstream commit edecfa98f602a597666e3c5cab2677ada38d93c5 ]
>>
>> Documentation/devicetree/bindings/net/dsa/dsa.txt says that the phy-mode
>> property should be specified on port nodes. However, the microchip
>> drivers read it from the switch node.
>>
>> Let the driver use the per-port property and fall back to the old
>> location with a warning.
>>
>> Fix in-tree users.
>
>I don't think this patch is useful for stable users. It corrects a
>device tree layout issue. Any existing users of the functionality will
>have an odd, but working device tree and that will continue working
>(with a warning) after applying this patch. It just has a property on
>the "wrong" node. I don't think I'd like to update my device tree in a
>stable update.

I've dropped it, thanks!

-- 
Thanks,
Sasha
