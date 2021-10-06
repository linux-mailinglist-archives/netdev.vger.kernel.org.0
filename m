Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C06423E1D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238808AbhJFMvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238730AbhJFMvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 08:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94EDE60F59;
        Wed,  6 Oct 2021 12:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633524552;
        bh=E5lZpXanoKV/1QIoaU3zZX3ltqIP1NnyAvFloPV4JbQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TRcnFP8kaXhX9QIaNANQEvNfhUa58NLmSC5BQIlMfkuRQclBSZmyJF2TJPEIGg0/3
         c8frrOjd2sMyi38it4tEN05c9g8nw1qXwTtp1OOtSzo7OjC9eHiH72Wxxx441tMhVY
         WGjcZhg/nWMF4FK0391vGOyyy3zsC0u3lzF4FLAuXpId9d3VS7r+cGwgl2JLPt97cc
         KRR6Xi7HCdHnyGkqZK5w/HcJkzXgEGJ2bs11gLQJiBJZMd23l62GXALb+BG1kP9a3s
         TMXZHNIhINj7XIQ22XJrgl7Mox0LVKtO71w09gDD8a04Arlnz8D49zPCRj78xxCJpt
         k5a88kJP87m+w==
Date:   Wed, 6 Oct 2021 05:49:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@rothwell.id.au>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20211006054911.790cbf46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006144322.640b966a@elm.ozlabs.ibm.com>
References: <20211006122315.4e04fb87@canb.auug.org.au>
        <20211005185217.7fb12960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211006144322.640b966a@elm.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 14:43:22 +1100 Stephen Rothwell wrote:
> On Tue, 5 Oct 2021 18:52:17 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Applied, thanks. Is this the last one? ;)  
> 
> No idea :-(
> 
> > I wonder what happened to the kbuild bot :S  
> 
> Does it do ppc builds?

I thought it did, I get a build status email periodically with a list
of 135 builds. PPC is well represented there.
