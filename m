Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCABD2B836A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgKRRyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:54:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKRRyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 12:54:37 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAD1B2076C;
        Wed, 18 Nov 2020 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605722077;
        bh=ki6KLd7UNwmMFTFhe30qpM32e4nZnYotC/wC6ca1xFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gQDqEw/uh96hkSTtwrpxyJzNeTV7F08zmbTaXxfPMdqnsafu8RZSzl+suLurGvzr8
         +ejJwTeFaOrG53P0OrdDHo7Kjnmqe6sqb0VnRVKwk6bPSnITA0XtNEt0QeIyLKHJdl
         DP8S0lmgGOSVMzjEhT6irSNwAS7vrze69oqlDAXk=
Date:   Wed, 18 Nov 2020 09:54:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/2] enetc: Clean endianness warnings up
Message-ID: <20201118095435.633a6e2e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118095258.4f129839@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201117182004.27389-1-claudiu.manoil@nxp.com>
        <20201118095258.4f129839@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 09:52:58 -0800 Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 20:20:02 +0200 Claudiu Manoil wrote:
> > Cleanup patches to address the outstanding endianness issues
> > in the driver reported by sparse.  
> 
> Build bot says this doesn't apply to net-next, could you double check?

Hm, not sure what happened there, it does seem to apply now.

Could you resend regardless? Would be good to get this build tested.
