Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1F5315674
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhBITD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233440AbhBISv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:51:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1452364E31;
        Tue,  9 Feb 2021 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612895169;
        bh=Jz0JK48Orafd4J5E+nIWTO9fcLP1eHH9cCNJvB2TVRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q9DTTvxwKJbm+48jZi5HXxJRzw7e/k+3N/Q+mvB0nUOHnf8h2PfaLLjhN5uhbzBux
         5UBKFmokPgUl/0TrE4dij2n2wkMXljoK/V6pez2eCg12FLKmkrGTecD/XtW4NCPFDL
         EgBBJwsiT6iu1+ynXyyiVODUM0B+JOPG35JIOQjy/FpUtHdeJQS6fbG1FqyIkNDBOj
         l3yP58qruCmi0VMFwvga06hPyrYKndOOh8GDuCG11jjZXbSgsLY5toph+HWoXjUR//
         XCZY5s9OIz7yg2ZI/jW8HcXPl0se43x+/yNnjkDibmTGX90HE/B2BDWhjTK2b0Xgfo
         KXwXah1SoNRVw==
Date:   Tue, 9 Feb 2021 10:26:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <andrew@lunn.ch>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v4 net-next 0/7] ethtool support for fec and link
 configuration
Message-ID: <20210209102606.5f3fd258@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
References: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 16:05:24 +0530 Hariprasad Kelam wrote:
> v4:
> 	- Corrected indentation issues
> 	- Use FEC_OFF if user requests for FEC_AUTO mode
> 	- Do not clear fec stats in case of user changes
> 	  fec mode
> 	- dont hide fec stats depending on interface mode
> 	  selection

What about making autoneg modes symmetric between set and get?
