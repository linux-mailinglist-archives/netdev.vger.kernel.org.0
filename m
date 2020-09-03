Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C40425C8B2
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 20:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgICS2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 14:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgICS2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 14:28:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B33420716;
        Thu,  3 Sep 2020 18:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599157728;
        bh=eMDqQ2ny+D2m9qXbdSlnpK3oELMV4uaVV5Cp6hIv5LU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FAE1PjT7bJm0NNS1q0knzX8/rEDlugoK/sGYIAvcnhACT/QazQzrqE+I4rSh8Aw8T
         WmPfXvzMIa1MPZDp+Ihn2YzUAQs73ru+7pBeHOz7k43jQ5N1X4JQSHLJqwIFCfNPHx
         zxDUHDw8UKG3/eAPDjNdV3MZYUq7clpMWAnbEP5A=
Date:   Thu, 3 Sep 2020 11:28:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 4/9] gve: Add support for dma_mask register
Message-ID: <20200903112846.5238ae0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL9ddJc9oCBijLtvGRmuMFNarKVcUwyPLhZD6HtLLubmXWFNmg@mail.gmail.com>
References: <20200901215149.2685117-5-awogbemila@google.com>
        <20200901173410.5ce6a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL9ddJciz2MD8CYqdbFLhYCKFk=ouHzzEndQwmcfQ-UqNNgJxQ@mail.gmail.com>
        <20200902.160831.2194160080454145229.davem@davemloft.net>
        <CAL9ddJc9oCBijLtvGRmuMFNarKVcUwyPLhZD6HtLLubmXWFNmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 09:31:16 -0700 David Awogbemila wrote:
> Thanks, I'll adjust this.

Please don't top post.

> On Wed, Sep 2, 2020 at 4:08 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: David Awogbemila <awogbemila@google.com>
> > Date: Wed, 2 Sep 2020 11:42:37 -0700
> >  
> > > I don't think there is a specific 24-bit device in mind here, only
> > > that we have seen 32-bit addressing use cases where the guest ran out
> > > of SWIOTLB space and restricting to GFP_DMA32 helped.. so we thought
> > > it would be natural for the driver to handle the 24 bit case in case
> > > it ever came along.  

I see. That's clear enough, no need to CC anyone extra. Please just
make sure you make the motivation clear in your commit message.
