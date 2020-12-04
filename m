Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AE2CF196
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbgLDQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbgLDQJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 11:09:00 -0500
Date:   Fri, 4 Dec 2020 08:08:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607098100;
        bh=qaDlz2vEh/zZ7nxnn5fo0Fwy/Y3K5EUTw9odTo2U0Qc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LpUkf69BsgmYnFJ6Ufj1mxcpeT+0+wVc6AzpVNESrZd6gG3vkB6GDzhbkT5PyShd1
         zzK9gnMvPts5WZywyJ5edVWkCdnbZYX+R74maPsZxM0hRSOxFzfyJ0iltExqdIXuB2
         RMr5q0AxVQCN0Dwhwj/win8mgFJ+/M4Lr5OdrKgjRYS3M2VQZegaUW+6Sn2rKJ74fS
         qd3XM01eFKbGTW/C0TURtCq3X6gSCRif/xEem1k+5LlT2Gua7syBYEwaffMTboM7Fa
         sa04R9p7jrjriRkGMLo7fZkGA/0M/T9c0f39VE4KCUpzsuUBg3OE5+ZFFs1rP7akJr
         esl1xyn3rgahg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, brouer@redhat.com
Subject: Re: [PATCH net-next] net: netsec: add xdp tx return bulking support
Message-ID: <20201204080818.33a321e2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <X8pCuq9gewShGGUL@apalos.home>
References: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
        <20201120100007.5b138d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201120180713.GA801643@apalos.home>
        <20201120101434.3f91005a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <X8pCuq9gewShGGUL@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 16:07:54 +0200 Ilias Apalodimas wrote:
> > > I had everything applied trying to test, but there was an issue with the PHY the
> > > socionext board uses [1].  
> > 
> > FWIW feel free to send a note saying you need more time.
> >   
> > > In any case the patch looks correct, so you can keep it and I'll report any 
> > > problems once I short the box out.  
> > 
> > Cool, fingers crossed :)  
> 
> FWIW I did eventually test this. 
> I can't see anything wrong with it.

Good to know, thank you!
