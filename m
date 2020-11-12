Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEC62B09A4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgKLQNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgKLQNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:13:13 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB6E622227;
        Thu, 12 Nov 2020 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605197593;
        bh=szils6tcEcwwVZZ4gp8vhFScN28Lkvc8EBBHksEFcks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p31NeE54E7p/+JXUrncHbgL6Xb8FPe6NQpS9T+m5uiAsPN0Oh/ObvmpWYYDjo4ImL
         lqIqAY2e1dOS9hjrU1gyVb9x4r9mVPiQdHq+mAPngf+6y7gQxwT3JOCZZ19junOye6
         CQ9r6a693ioDcpmOx9nzsJCM3/XZB/lPSZJlr5pg=
Date:   Thu, 12 Nov 2020 11:13:11 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-gpio@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [4.4] Security fixes (pinctrl, i40e, geneve)
Message-ID: <20201112161311.GE403069@sasha-vm>
References: <f5e2e87fb1a9613b161e63cf5504cc375e095dbc.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f5e2e87fb1a9613b161e63cf5504cc375e095dbc.camel@codethink.co.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:43:56PM +0000, Ben Hutchings wrote:
>Here are backports of some fixes to the 4.4 stable branch.
>
>I wasn't able to test the pinctrl fix (no idea how to reproduce it).
>
>I wasn't able to test the i40e changes (no hardware and no reproducer
>available).
>
>I tested the geneve fix with libreswan as (roughly) described in the
>commit message.

Queued up, thanks Ben!

-- 
Thanks,
Sasha
