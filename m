Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6927EE2C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgI3QDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:03:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:51256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3QDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:03:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A3518AD2C;
        Wed, 30 Sep 2020 16:03:03 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3F3D060787; Wed, 30 Sep 2020 18:03:03 +0200 (CEST)
Date:   Wed, 30 Sep 2020 18:03:03 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, johannes@sipsolutions.net,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930160303.uymslyt5isgzcl67@lion.mk-sys.cz>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:49:55AM -0700, Jakub Kicinski wrote:
> Hi!
> 
> I'd like to be able to dump ethtool nl policies, but right now policy
> dumping is only supported for "global" family policies.
> 
> Is there any reason not to put the policy in struct genl_ops, 
> or just nobody got to it, yet?
> 
> I get the feeling that this must have been discussed before...

It used to be per-cmd but with common maxattr which didn't make much
sense. In 5.2 cycle, commit 3b0f31f2b8c9 ("genetlink: make policy common
to family") changed it to common policy for each family.

Michal
