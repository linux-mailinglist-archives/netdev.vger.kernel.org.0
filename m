Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0637C280BB9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 02:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbgJBAgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 20:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgJBAgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 20:36:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F21620848;
        Fri,  2 Oct 2020 00:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601599006;
        bh=5V+BcVa6cB37xkGX50OVZCBoxlz9IdAt18X8MtB5MMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bCWlzNd+1DHqHhCX/IoXOj/IhrpIAYlMl3UNe3jmOrVevpCdHOFDym7t9N0w7KI/n
         +QRMHlDDgRg5UAgSPDcuIOnpEkZmFpRi5BUmLs1lgpSmmhw9e1SIveatO4zhoS7tkk
         df6UMDzqbG2/Ad/5PdY+o9kWXPKVkw36Yqm89+9Y=
Date:   Thu, 1 Oct 2020 17:36:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001225933.1373426-1-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 15:59:23 -0700 Jakub Kicinski wrote:
> Hi!
> 
> The objective of this series is to dump ethtool policies
> to be able to tell which flags are supported by the kernel.
> Current release adds ETHTOOL_FLAG_STATS for dumping extra
> stats, but because of strict checking we need to make sure
> that the flag is actually supported before setting it in
> a request.

Do we need support for separate .doit and .dumpit policies?
Or is that an overkill?
