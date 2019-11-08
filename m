Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF076F568A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403813AbfKHTJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:09:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403798AbfKHTJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:09:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3E03153A02C2;
        Fri,  8 Nov 2019 11:09:23 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:09:21 -0800 (PST)
Message-Id: <20191108.110921.1805146824772140727.davem@davemloft.net>
To:     alexander.sverdlin@nokia.com
Cc:     netdev@vger.kernel.org, jarod@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: octeon_mgmt: Account for second
 possible VLAN header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108100024.126857-1-alexander.sverdlin@nokia.com>
References: <20191107.151409.1123596566825003561.davem@davemloft.net>
        <20191108100024.126857-1-alexander.sverdlin@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 11:09:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Date: Fri, 8 Nov 2019 10:00:44 +0000

> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Octeon's input ring-buffer entry has 14 bits-wide size field, so to account
> for second possible VLAN header max_mtu must be further reduced.
> 
> Fixes: 109cc16526c6d ("ethernet/cavium: use core min/max MTU checking")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
> Changelog:
> v2: Added "Fixes:" tag, Cc'ed stable

Networking patches do not CC: stable, as per the Netdev FAQ
