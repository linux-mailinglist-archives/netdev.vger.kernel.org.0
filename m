Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D47517875C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgCDBEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:04:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgCDBEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:04:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 636E015AD44E2;
        Tue,  3 Mar 2020 17:04:10 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:04:09 -0800 (PST)
Message-Id: <20200303.170409.932957753900594502.davem@davemloft.net>
To:     me@pmachata.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH net-next 0/4] selftests: Use busywait() in a couple
 places
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1583170249.git.petrm@mellanox.com>
References: <cover.1583170249.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:04:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <me@pmachata.org>
Date: Mon,  2 Mar 2020 19:56:01 +0200

> From: Petr Machata <petrm@mellanox.com>
> 
> Two helper function for active waiting for an event were recently
> introduced: busywait() as the active-waiting tool, and until_counter_is()
> as a configurable predicate that can be plugged into busywait(). Use these
> in tc_common and mlxsw's qos_defprio instead of hand-coding equivalents.
> 
> Patches #1 and #2 extend lib.sh facilities to make the transition possible.
> Patch #3 converts tc_common, and patch #4 qos_defprio.

Series applied, thanks.
