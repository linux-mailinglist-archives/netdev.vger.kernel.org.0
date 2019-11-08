Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E49F3C9E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKHAPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:15:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50548 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHAPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:15:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34E1915385172;
        Thu,  7 Nov 2019 16:15:18 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:15:17 -0800 (PST)
Message-Id: <20191107.161517.1787564380364932585.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, hd@os-cillation.de,
        mark.tomlinson@alliedtelesis.co.nz
Subject: Re: [PATCH net] ipv4: Fix table id reference in fib_sync_down_addr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107182952.4352-1-dsahern@kernel.org>
References: <20191107182952.4352-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:15:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  7 Nov 2019 18:29:52 +0000

> Hendrik reported routes in the main table using source address are not
> removed when the address is removed. The problem is that fib_sync_down_addr
> does not account for devices in the default VRF which are associated
> with the main table. Fix by updating the table id reference.
> 
> Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
> Reported-by: Hendrik Donner <hd@os-cillation.de>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied and queued up for -stable, thanks David.
