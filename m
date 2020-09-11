Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB6B266547
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgIKQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgIKPFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:05:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A363222E7;
        Fri, 11 Sep 2020 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599836117;
        bh=UBc5WNuPQYUcmUI+gnu0Z+iU3e58vtUR4oq2800t3vY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ksVYEceYca6dn20TQzhx0m3RxO1bI9m4gfDecykVW3KQxGE3GbcD1pHTe9/94QfCl
         hJa1Op39JFk8OzCUSNDtAdkzWqEw6XEpSmFJpiESpI9PXXFvJeuc1XnblJxyTdcS5M
         14Kq9AaPmk2/9Y/oBf/KBO9N48Vjsmljv8xZanHI=
Date:   Fri, 11 Sep 2020 07:55:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 00/11] make drivers/net/ethernet W=1
 clean
Message-ID: <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 18:23:26 -0700 Jesse Brandeburg wrote:
> This series is a placeholder to show I've about finished this work.
> 
> After applying the patches below, the drivers/net/ethernet
> directory can be built as modules with W=1 with no warnings.
> 
> This series removes 1,283 warnings and hopefully allows the ethernet
> directory to move forward from here without more warnings being added.
> 
> Some of these patches are already sent to Intel Wired Lan, but the rest
> of the series titled drivers/net/ethernet affects other drivers, not
> just Intel, but they depend on the first five.

Great stuff. Much easier to apply one large series than a thousand
small patches. I haven't read all the comment changes but FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

I feel slightly bad for saying this but I think your config did not
include all the drivers, 'cause I'm still getting some warnings after
patch 11. Regardless this is impressive effort, thanks!
