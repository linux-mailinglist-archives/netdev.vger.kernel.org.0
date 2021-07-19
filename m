Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B015A3CD2BD
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhGSKIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236588AbhGSKH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3BD460FF4;
        Mon, 19 Jul 2021 10:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626691719;
        bh=x3sZ6QziQFQPBoDXFlrxzz/Xw1YdKNKJ1dEfsJ5U9Ks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ofS4LFKVQCiq4PmWj9sATGQpAMPLVg8AXo/1S0/5N5ZLUYlqzT9WdpgY5uM6XmeXg
         tlG1LVugELHTm8WvKL+fiv6X6TWrwY+AqzOBQ8hHuMlwFPkm4zBzSbX0Z02tDqJv0r
         OR0pdXsFD5YoQhNgFIhTZnd9z4iatdW41KnENeyxh+QqmIifxzjzJtoXGsxStxekpa
         PWG+TLb7zco+Ms33rdkBWuuXauBFwFwC1vTb9LPZqkqepjwY9D4QNV3D+tHhkHn78i
         nYXPXbQZ0x01203vLQeBzZFUKvVgWDiGUjWMgER+5UvuDeXgV4mRg/u3yQ8hAubx76
         TcxxH7iiwdkiw==
Date:   Mon, 19 Jul 2021 12:48:29 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de,
        steven.liu@mediatek.com
Subject: Re: [PATCH net, v2] net: Update MAINTAINERS for MediaTek switch
 driver
Message-ID: <20210719124829.3a5ca4da@cakuba>
In-Reply-To: <d62aa80d-9ee2-23b8-f68f-449b488a3b0f@gmail.com>
References: <20210601024508.iIbiNrsg-6lZjXwIt9-j76r37lcQSk3LsYBoZyl3fUM@z>
        <20210717154523.82890-1-dqfext@gmail.com>
        <d62aa80d-9ee2-23b8-f68f-449b488a3b0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Jul 2021 09:10:19 -0700, Florian Fainelli wrote:
> On 7/17/2021 8:45 AM, DENG Qingfang wrote:
> > On Tue, Jun 01, 2021 at 10:45:08AM +0800, Landen Chao wrote:  
> >> Update maintainers for MediaTek switch driver with Deng Qingfang who
> >> contributes many useful patches (interrupt, VLAN, GPIO, and etc.) to
> >> enhance MediaTek switch driver and will help maintenance.
> >>
> >> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> >> Signed-off-by: DENG Qingfang <dqfext@gmail.com>  
> > 
> > Ping?  
> 
> You might have to resend

Yes, please resend, there may have been something funny with v2 because
patchwork didn't pick it up. It also broke threading in my MUA. Please
make sure v3 will have a different message ID header than v2.
