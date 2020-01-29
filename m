Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8104214C890
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgA2KMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:12:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgA2KMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 05:12:48 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B57ED15C0123E;
        Wed, 29 Jan 2020 02:12:46 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:12:45 +0100 (CET)
Message-Id: <20200129.111245.1611718557356636170.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v2 2/3] taprio: Allow users not to specify "flags"
 when changing schedules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200128235227.3942256-3-vinicius.gomes@intel.com>
References: <20200128235227.3942256-1-vinicius.gomes@intel.com>
        <20200128235227.3942256-3-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 02:12:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Tue, 28 Jan 2020 15:52:26 -0800

> When any offload mode is enabled, users had to specify the
> "flags" parameter when adding a new "admin" schedule.
> 
> This fix allows that parameter to be omitted when adding a new
> schedule.
> 
> This will make that we have one source of truth for 'flags'.
> 
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This will visibly change behavior for a feature in a released
kernel (v5.3 and later) and it means that newer tools will do
things that don't work in older kernels.

I think your opportunity to adjust these semantics, has therefore,
long passed.

Sorry.
