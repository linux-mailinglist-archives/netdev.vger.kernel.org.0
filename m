Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9A7CF509
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfJHIaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:30:03 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:38186 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfJHIaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 04:30:02 -0400
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23990947AbfJHI37AjQK8 (ORCPT
        <rfc822;linux-kernel@vger.kernel.org> + 2 others);
        Tue, 8 Oct 2019 10:29:59 +0200
Date:   Tue, 8 Oct 2019 09:29:58 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Colin King <colin.king@canonical.com>
cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netdevsim: fix spelling mistake "forbidded" ->
 "forbid"
In-Reply-To: <20191008081747.19431-1-colin.king@canonical.com>
Message-ID: <alpine.LFD.2.21.1910080921350.25653@eddie.linux-mips.org>
References: <20191008081747.19431-1-colin.king@canonical.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019, Colin King wrote:

> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index a3d7d39f231a..ff6ced5487b6 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -486,7 +486,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
>  		/* For testing purposes, user set debugfs dont_allow_reload
>  		 * value to true. So forbid it.
>  		 */
> -		NL_SET_ERR_MSG_MOD(extack, "User forbidded reload for testing purposes");
> +		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for testing purposes");

 If nitpicking about grammar, then FWIW I believe it should actually be:

		NL_SET_ERR_MSG_MOD(extack, "User forbade the reload for testing purposes");

(and then:

		NL_SET_ERR_MSG_MOD(extack, "User set up the reload to fail for testing purposes");

elsewhere).

  Maciej
