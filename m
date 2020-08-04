Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3484123C206
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgHDXEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHDXEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:04:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B9C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:04:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A40412896238;
        Tue,  4 Aug 2020 15:47:21 -0700 (PDT)
Date:   Tue, 04 Aug 2020 16:04:05 -0700 (PDT)
Message-Id: <20200804.160405.493186148232912527.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] ptp: only allow phase values lower than 1
 period
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803194921.603151-1-olteanv@gmail.com>
References: <20200803194921.603151-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:47:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  3 Aug 2020 22:49:21 +0300

> The way we define the phase (the difference between the time of the
> signal's rising edge, and the closest integer multiple of the period),
> it doesn't make sense to have a phase value larger than 1 period.
> 
> So deny these settings coming from the user.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Richard, I need your review on this patch.

Thank you.
