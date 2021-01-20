Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F22FD69D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391002AbhATRM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391806AbhATRKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 12:10:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86CBE2242A;
        Wed, 20 Jan 2021 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611162566;
        bh=26/MeIDWZppPspshO91YBEvUcO5p41dFfZ13wYEOjqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a8naZ8F3OQ2QoBkIx84tQFWaxx36APOYxnPKAOr1xV47uDLoo+AgyD1fpxtTa52Tv
         ZZDUqYPC0Af+KaR7hUYfDd9xKnljHqRzbaW+Gz5SozDNTlo1gB6rPHC+4/D7EvBaxM
         GN5QitubveIk3ePjFH6+d0J5Ep+hbd3Ckd7p6xsylN9AN99iyTXwBXZXp2hsgEwVLE
         Es//oH9OmHEN04CzZu++gmLGU/ggC0IZFGy6VBStTcgY/mi/O6HsFEsAq25ueT74/I
         LaANloLGPnVANJzqm3YcrJAX0t/3PtE8BcjkkiK7+YgujW6p/kNHk6Ze9D4EEXvvxm
         wkUUgxX2euWcQ==
Date:   Wed, 20 Jan 2021 09:09:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pan Bian <bianpan2016@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: systemport: free dev before on error path
Message-ID: <20210120090925.69b3347b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c291aebe-4cb4-9fe7-0635-5b518d92c311@gmail.com>
References: <20210120044423.1704-1-bianpan2016@163.com>
        <c291aebe-4cb4-9fe7-0635-5b518d92c311@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 21:07:10 -0800 Florian Fainelli wrote:
> On 1/19/2021 8:44 PM, Pan Bian wrote:
> > On the error path, it should goto the error handling label to free
> > allocated memory rather than directly return.
> > 
> > Fixes: 6328a126896e ("net: systemport: Manage Wake-on-LAN clock")
> > Signed-off-by: Pan Bian <bianpan2016@163.com>  
> 
> The change is correct, but not the Fixes tag, it should be:
> 
> Fixes: 31bc72d97656 ("net: systemport: fetch and use clock resources")
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thank you!
