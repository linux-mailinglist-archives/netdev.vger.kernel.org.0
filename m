Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2263D83
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfGIVsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:48:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbfGIVsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:48:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96EA01424FE8A;
        Tue,  9 Jul 2019 14:48:01 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:48:01 -0700 (PDT)
Message-Id: <20190709.144801.846417727783566863.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, vedang.patel@intel.com
Subject: Re: [PATCH net-next] pkt_sched: Include const.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709214517.31684-1-dsahern@kernel.org>
References: <20190709214517.31684-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:48:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue,  9 Jul 2019 14:45:17 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Commit 9903c8dc7342 changed TC_ETF defines to use _BITUL instead of BIT
> but did not add the dependecy on linux/const.h. As a consequence,
> importing the uapi headers into iproute2 causes builds to fail. Add
> the dependency.
> 
> Fixes: 9903c8dc7342 ("etf: Don't use BIT() in UAPI headers.")
> Cc: Vedang Patel <vedang.patel@intel.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
