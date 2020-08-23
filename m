Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2A24EBEC
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 09:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHWHEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 03:04:45 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:59845 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgHWHEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 03:04:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id D1F80A20;
        Sun, 23 Aug 2020 03:04:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 03:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YL875o
        xAQ3rCZ2SLFY4uDo7/SdoRl3BPTTquWsxPeVg=; b=TAxu9BlFC3DhRvNLK6JKF0
        T8X70sM822a9kr8qHxn8tu1WUr3WIzD+i3Brh5NpAZsF4nGQYFsE+BE+VmoY8aCN
        HyFeQayqTdZXhr1TVxsAtAXm5wTwdlnBDewQK01VplhPF2HjJtuiUrkKXBaedJIX
        LOTzEeM86IrJUW5P+hYZX5S7G1lfb73T5v8THilRsbmmwG5ufV0IILJ6dtAx0+UJ
        ir7MVswjX/l6nVxJ/FTXxydnv5OfuIavIfq3XpDTrBxhs37md8dKsJE1SWFSJwGQ
        zr8M9OmosPUl6OkuK4uoEYwCBPvLC2RYsa3L6Whel1VRBIay6By3RkSVr0iGrL+g
        ==
X-ME-Sender: <xms:BRVCX4QGZ16ZRUiAxeqJu6GtuVkct6s3stJ6rfQ4h77ayVUy3tkpVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduhedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeejledrudejkedrudefuddrfeehnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BRVCX1x6XoPuQeA0AG-5ytYnxRAG461UPPz6KTwiMHnbEliGWclLBg>
    <xmx:BRVCX10ZWV2zCPCPm5t02FnT2ulW4LPhaokbR_rk7ZNRleKlvUmrpA>
    <xmx:BRVCX8DGWBiLo3KEBDqG9IhZnLxrcM7sz1Wuj2BsJT6S7lpLmfWZjw>
    <xmx:BhVCX8oTe2YAiK9BMpcpyyzu_EtBo219V-GLkJOvyQfPwFNI9Hmp2t-gHMk>
Received: from localhost (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08B1B328005A;
        Sun, 23 Aug 2020 03:04:36 -0400 (EDT)
Date:   Sun, 23 Aug 2020 10:04:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200823070434.GA400109@shredder>
References: <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
 <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
 <20200821103021.GA331448@shredder>
 <20200821095303.75e6327b@kicinski-fedora-PC1C0HJN>
 <6030824c-02f9-8103-dae4-d336624fe425@gmail.com>
 <20200821165052.6790a7ba@kicinski-fedora-PC1C0HJN>
 <1e5cdd45-d66f-e8e0-ceb7-bf0f6f653a1c@gmail.com>
 <20200821173715.2953b164@kicinski-fedora-PC1C0HJN>
 <90b68936-88cf-4d87-55b0-acf9955ef758@gmail.com>
 <20200822092739.5ba0c099@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822092739.5ba0c099@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 09:27:39AM -0700, Jakub Kicinski wrote:
> On Fri, 21 Aug 2020 19:18:37 -0600 David Ahern wrote:
> > On 8/21/20 6:37 PM, Jakub Kicinski wrote:
> > >>> # cat /proc/net/tls_stat     
> > >>
> > >> I do not agree with adding files under /proc/net for this.  
> > > 
> > > Yeah it's not the best, with higher LoC a better solution should be
> > > within reach.  
> > 
> > The duplicity here is mind-boggling. Tls stats from hardware is on par
> > with Ido's *example* of vxlan stats from an ASIC. You agree that
> > /proc/net files are wrong,
> 
> I didn't say /proc/net was wrong, I'm just trying to be agreeable.
> Maybe I need to improve my command of the English language.
> 
> AFAIK /proc/net is where protocol stats are.
> 
> > but you did it anyway and now you want the
> > next person to solve the problem you did not want to tackle but have
> > strong opinions on.
> 
> I have no need and interest in vxlan stats.
> 
> > Ido has a history of thinking through problems and solutions in a proper
> > Linux Way. netlink is the right API, and devlink was created for
> > 'device' stuff versus 'netdev' stuff. Hence, I agree with this
> > *framework* for extracting asic stats.
> 
> You seem to focus on less relevant points. I primarily care about the
> statistics being defined and identified by Linux, not every vendor for
> themselves.

Trying to understand how we can move this forward. The issue is with the
specific VXLAN metrics, but you generally agree with the need for the
framework? See my two other examples: Cache counters and algorithmic
TCAM counters.

> No question about Ido's ability and contributions, but then again 
> (from the cover letter):
> 
> > This a joint work [...] during a two-day company hackathon.

The *implementation* was done during the hackathon. The *design* was
done before. I sent to the team three design proposals (CLI / netlink
API / device drivers API) before we landed on this. Started thinking
about this idea a few months ago and the hackathon was simply a good
opportunity to implement and showcase it.
