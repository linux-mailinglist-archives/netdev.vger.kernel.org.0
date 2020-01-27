Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3148C14A16A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgA0KEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:04:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgA0KEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:04:07 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CA88151091C2;
        Mon, 27 Jan 2020 02:04:03 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:04:01 +0100 (CET)
Message-Id: <20200127.110401.1796031469611767602.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com
Subject: Re: [patch net-next v2 0/4] net: allow per-net notifier to follow
 netdev into namespace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125111709.14566-1-jiri@resnulli.us>
References: <20200125111709.14566-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:04:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 25 Jan 2020 12:17:05 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently we have per-net notifier, which allows to get only
> notifications relevant to particular network namespace. That is enough
> for drivers that have netdevs local in a particular namespace (cannot
> move elsewhere).
> 
> However if netdev can change namespace, per-net notifier cannot be used.
> Introduce dev_net variant that is basically per-net notifier with an
> extension that re-registers the per-net notifier upon netdev namespace
> change. Basically the per-net notifier follows the netdev into
> namespace.

Series applied, thanks Jiri.
