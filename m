Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D68B1839BC
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgCLTpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgCLTpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 15:45:06 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0716E20637;
        Thu, 12 Mar 2020 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584042306;
        bh=nK7uKspYC164b/BVygKpJI8PL7re2FPZMilBLvV/RoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=el6HBikeWs53Ux/8NXf7XGD7YlhkNPd2IBI6ygttSzZid16BBMu4Pg75eM7Q72K91
         D6d54E7zP1iSHCcu7ZjLb68iFYOh0MeRksQNtUFRQadJUuQ5PRK9zyvUsmyZ/iJQMn
         KKi7j+Sq4LHXkyhMKNcYdh9hyLytYMCO0fDa58Ck=
Date:   Thu, 12 Mar 2020 12:45:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     David Miller <davem@davemloft.net>, borisp@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
Message-ID: <20200312124504.7ee481a9@kicinski-fedora-PC1C0HJN>
In-Reply-To: <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
References: <cover.1583896344.git.joe@perches.com>
        <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
        <20200311.232302.1442236068172575398.davem@davemloft.net>
        <cf74e8fdd3ee99aec86cec4abfdb1ce84b7fd90a.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 23:26:59 -0700 Joe Perches wrote:
> On Wed, 2020-03-11 at 23:23 -0700, David Miller wrote:
> > Joe, please use Subject line subsystem prefixes consistent with what would
> > be used for other changes to these drivers.  
> 
> Not easy to do for scripted patches.
> There's no mechanism that scriptable.

I have this to show me the top 3 prefixes used for files currently
modified in my tree:

tgs() {
    local fs

    fs=$(git status -s | sed -n 's/ M //p')

    git log --oneline --no-merges -- $fs | \
	sed -e's/[^ ]* \(.*\):[^:]*/\1/' | \
	sort | uniq -c | sort -rn | head -3
}

You could probably massage it to just give you to top one and feed 
that into git commit template?
