Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985FE477DC9
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhLPUog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhLPUof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:44:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DC7C061574;
        Thu, 16 Dec 2021 12:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29FA3B82619;
        Thu, 16 Dec 2021 20:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731FFC36AE2;
        Thu, 16 Dec 2021 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687472;
        bh=85egxkF8FrVkQyXoygVW6/r5UHA97A3kAl4SfuY5QMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DzeU5ur5PwPFdmqmxDqKroOXxkCAvl9gy5ex7+5IBo50U1PcbsfUWvaNcYyV+Ax5a
         FzDsVu+2OxfezUB4sSaQjWlRAlmI1Jx3nuOIyhrlJOozkRpRgd8J1CdJWSD5uh3jcL
         NPfsdRNVUsd+7xkqJ2hAj4eBiMXJpt/WmFTHK+QQ7/9cUXj144WfnIxSVJmCRvGwMg
         TsX7LEKGBM1qI2voJdSKjS8udenLJt09msDrnfVfIiFASvXdCQpHTON8t6ovzdcuzQ
         8UiKLcLm234z9vOYf5E0JMQ4iq23+SmAXmxWpC+VappG2X/xiQ4Jl7HvuPMYRXJHJw
         3c5pliAgE99+w==
Date:   Thu, 16 Dec 2021 12:44:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible
 UAF
Message-ID: <20211216124430.142a013c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Ybtrs56tSBbmyt5c@google.com>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
        <20211214215732.1507504-2-lee.jones@linaro.org>
        <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
        <Ybtrs56tSBbmyt5c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 16:39:15 +0000 Lee Jones wrote:
> > > You should squash the two patches together.  
> 
> I generally like patches to encapsulate functional changes.
> 
> This one depends on the other, but they are not functionally related.
> 
> You're the boss though - I'll squash them if you insist.

Yes, please squash them.
