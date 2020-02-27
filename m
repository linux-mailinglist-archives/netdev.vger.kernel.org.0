Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44DF172943
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbgB0UKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:10:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbgB0UKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:10:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD3DA12199AD4;
        Thu, 27 Feb 2020 12:10:16 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:10:16 -0800 (PST)
Message-Id: <20200227.121016.82578163363365930.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] mlxsw: reg: Update module_type values in PMTM
 register and map them to width
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227195926.20759-1-jiri@resnulli.us>
References: <20200227195926.20759-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 12:10:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 27 Feb 2020 20:59:26 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> There are couple new values that PMTM register can return
> in module_type field. Add them and map them to module width in
> mlxsw_core_module_max_width(). Fix the existing names on the way.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
