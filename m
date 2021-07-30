Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1983DB952
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbhG3N26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238926AbhG3N25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58FC60EFF;
        Fri, 30 Jul 2021 13:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627651733;
        bh=6cUNpTEpCjdVhmy4dYzGo7E9CQFWo+Eq5w2YWTpenR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I7FnHh7JuJe66PDfWEvRk9kDgIo77CqZLMzHk0DUwhBSu5AmDytrV4GUnzh7/UFfw
         NuvDwWuVpLAnNQk12fHQ5avzlfeFXRZ6WwOP8uuV6ihqeJ4Rt55EhFR8cG6O+lIc4V
         RxWCx6OhHMqFuq+CzW8PN/pOVtwaodeGiFs5SoXHAcbb8d2o8xAHn2lV1vtozD+Yb7
         arh5bpY3AWS9eWw+kKwqI38Vy4IQiMeDtFVg1zldpUbY/2aQ2XQZLVZEsWS/WwP5OB
         TuUxcxWhqcIIuv4VF0eVGGkGcsP8I/aDOAj3Q9RHns9Pv1IHjDdVJ22zDF0auZPpqY
         V+Z2P//QNrFeg==
Date:   Fri, 30 Jul 2021 06:28:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm63xx_enet: simplify the code in bcm_enet_open()
Message-ID: <20210730062852.3d41cc52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d5079143-00e3-75d3-cdb0-037c377c526e@gmail.com>
References: <20210729070627.23776-1-tangbin@cmss.chinamobile.com>
        <d5079143-00e3-75d3-cdb0-037c377c526e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Jul 2021 14:23:28 -0700 Florian Fainelli wrote:
> On 7/29/21 12:06 AM, Tang Bin wrote:
> > In the function bcm_enet_open(), 'ret = -ENOMEM' can be moved
> > outside the judgement statement, so redundant assignments can
> > be removed to simplify the code.
> > 
> > Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>  
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

I wouldn't, the existing code is more robust IMO, but your call :)

Does not apply to net-next, please rebase.
