Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D823CEE6
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHETIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgHETHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 15:07:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A8CC061575
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 12:07:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FC51152E6F3F;
        Wed,  5 Aug 2020 11:50:40 -0700 (PDT)
Date:   Wed, 05 Aug 2020 12:07:22 -0700 (PDT)
Message-Id: <20200805.120722.981424444246760545.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH v3 net-next] ptp: only allow phase values lower than 1
 period
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805001047.1372299-1-olteanv@gmail.com>
References: <20200805001047.1372299-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 11:50:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed,  5 Aug 2020 03:10:47 +0300

> The way we define the phase (the difference between the time of the
> signal's rising edge, and the closest integer multiple of the period),
> it doesn't make sense to have a phase value equal or larger than 1
> period.
> 
> So deny these settings coming from the user.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thank you.
