Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E5E168AA7
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 01:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgBVACv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 19:02:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729541AbgBVACs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 19:02:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C920415828FF7;
        Fri, 21 Feb 2020 16:02:45 -0800 (PST)
Date:   Fri, 21 Feb 2020 16:02:45 -0800 (PST)
Message-Id: <20200221.160245.469174158019285535.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] net: Remove unneeded export of a couple of
 xdp generic functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221050313.68171-1-dsahern@kernel.org>
References: <20200221050313.68171-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 16:02:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu, 20 Feb 2020 22:03:13 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> generic_xdp_tx and xdp_do_generic_redirect are only used by builtin
> code, so remove the EXPORT_SYMBOL_GPL for them.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
