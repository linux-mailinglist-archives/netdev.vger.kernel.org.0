Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1604028169A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388322AbgJBP3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387984AbgJBP3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:29:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82AB206DC;
        Fri,  2 Oct 2020 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601652552;
        bh=C7vTverLdRNo9bIYmatLP+3W5HGIUob3f1oPI5go6gU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zk1sXc1VpBhyDlKk47X9GcxYtbsKsSlF0tlYpQeS7I9rBpeH5zcDh4zhgcO5Qtnqi
         VRBVQtp3FtT9cTWDMXwXGHo1ikor/VGWkxd7RE79tQX90IskgNy2TA2H6+Bv38b931
         Hch5aDWWeTorXBk3fvRdr+aGHyqHt3LahLrgFAbc=
Date:   Fri, 2 Oct 2020 08:29:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] netlink: fix policy dump leak
Message-ID: <20201002082910.6951a5db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid>
References: <20201002094604.480c760e3c47.I7811da1539351a26cd0e5a10b98a8842cfbc1b55@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 09:46:04 +0200 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If userspace doesn't complete the policy dump, we leak the
> allocated state. Fix this.
> 
> Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

FWIW make sure to mark the patches with net and net-next in the tag. 
The more automation we have, the more it matters.
