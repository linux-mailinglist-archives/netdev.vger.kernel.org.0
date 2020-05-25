Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B611E151C
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbgEYUJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgEYUJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 16:09:50 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA2402070A;
        Mon, 25 May 2020 20:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590437390;
        bh=nZnYYQH4PAnWSSY9jzFQKCviaHhbi9MNUkbyVAYgHRY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1tT/cBMjAbL6dLFwf8AfHYhwYvxwFviaD9hygv5D8xSOc4aQCdr360XIy624hgy3b
         3eG1qVD+wVPe/KR0M54XSeHDdl72/bbPOKZ+R01YFstdmRerhepHDyA34AZFwKJ9oX
         9urk4ztwLcAuNgmNxuHQMMOollj6UZJXDazAkMOY=
Date:   Mon, 25 May 2020 13:09:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Starovoytov <mstarovoitov@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 01/12] net: atlantic: changes for
 multi-TC support
Message-ID: <20200525130948.157ca135@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CH2PR18MB3238B6DC3153AF4A38038454D3B40@CH2PR18MB3238.namprd18.prod.outlook.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
        <20200522081948.167-2-irusskikh@marvell.com>
        <20200522105831.4ab00ca5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CH2PR18MB3238B6DC3153AF4A38038454D3B40@CH2PR18MB3238.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 19:47:37 +0000 Mark Starovoytov wrote:
> > > * use AQ_HW_*_TC instead of hardcoded magic numbers;
> > > * actually use the 'ret' value in aq_mdo_add_secy();  
> > 
> > Whenever you do an enumeration like this - it's a strong indication that those
> > should all be separate patches. Please keep that in mind going forward.  
> 
> Understood, but I've also seen a recommendation that a single
> patchset shouldn't have more than 15 patches (if my memory doesn't
> fail me). And unfortunately it would have been impossible to meet the
> 15 patches limit, if all these small changes were in separate
> patches. What's the best/recommended approach in this case?

Non-functional changes like that will usually get reviewed and merged
within 24 hours, so if series gets longer than 15 patches I'd personally
separate low-risk / refactoring changes into a series of their own. 
And then post the rest of the code once they get merged.
