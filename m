Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21EB16EEC8
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgBYTNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:13:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbgBYTNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:13:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91EE513B490A4;
        Tue, 25 Feb 2020 11:13:39 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:13:39 -0800 (PST)
Message-Id: <20200225.111339.990273097730952856.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [patch net-next] iavf: use tc_cls_can_offload_basic() instead
 of chain check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225121023.6011-1-jiri@resnulli.us>
References: <20200225121023.6011-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 11:13:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 25 Feb 2020 13:10:23 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Looks like the iavf code actually experienced a race condition, when a
> developer took code before the check for chain 0 was put to helper.
> So use tc_cls_can_offload_basic() helper instead of direct check and
> move the check to _cb() so this is similar to i40e code.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> This was originally part of "net: allow user specify TC filter HW stats type"
> patchset, but it is no longer related after the requested changes.
> Sending separatelly.

Jeff, do you want me to apply this directly?  If so, please give your ack.

Thanks.
