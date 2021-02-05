Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8062931115D
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhBER55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhBERzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 12:55:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66E0464FA7;
        Fri,  5 Feb 2021 19:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612553822;
        bh=/gX0OD27ow5lqaz6csW9tzgTNpjlDXPHR9Qsl/CpQiQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z0L5gRUsftDjgSMx+rscQWPCvGd/74vohM5tbAg107JMu8pKJDJ0RqtHS37EcN+4T
         gw/wNxME62LPY7wzKxQ2KiDzrsjKUkKgT/5ufmZp1LY7KgLVHKinb63d2mBGNr1ssU
         EMRc58MnXr7P9sxSzbDoUQ1CIwc68UL5WGPBTGifc0wjceeqaGar1zK1EmLu14HJBf
         ZJx5O154gspkHmDaCAISGbEuukWTq6eVOrnzesinaqma/uFpCYH1YfrNBSQ6ko1nO3
         XeUcYXQDjdXG5SKKUd/doBoo+6OGma0HLB+4ElHaMu4DmVM1pP2Q3jt0bx4ZAIsKBH
         P3EOlPp/Qc/pA==
Date:   Fri, 5 Feb 2021 11:37:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Simon Wunderlich <sw@simonwunderlich.de>, davem@davemloft.net,
        netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Message-ID: <20210205113701.4ab0e1a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4678664.8dpOeDNDtA@ripper>
References: <20210202174037.7081-1-sw@simonwunderlich.de>
        <3636307.aAJz7UTs6F@ripper>
        <20210204115836.4f66e1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4678664.8dpOeDNDtA@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 05 Feb 2021 08:47:38 +0100 Sven Eckelmann wrote:
> On Thursday, 4 February 2021 20:58:36 CET Jakub Kicinski wrote:
> > Back when I was working for a vendor I had a script which used git to
> > find files touched in current year and then a bit of sed to update the
> > dates. Instead of running your current script every Jan, you can run
> > that one every Dec.  
> 
> Just as an additional anecdote: Just had the situation that a vendor 
> complained that the user visible copyright notice was still 2020 for a project 
> published in 2021 but developed and tested 2020 (and thus tagged + packaged in 
> 2020).
> 
> Now to something more relevant: what do you think about dropping the copyright 
> year [1]?

Interesting! In my own code I do option 1, copyright protection is
longer than the code I write is relevant :S 

3 seems to be what US lawyers like but frankly in the git era they are
probably overly lazy^W cautious.

Option 4 seems nice as well - it's really up to you(r lawyer).
