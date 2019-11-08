Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC54F572F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390538AbfKHTTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:19:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387621AbfKHTTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:19:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D889E153A41BE;
        Fri,  8 Nov 2019 11:19:01 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:19:01 -0800 (PST)
Message-Id: <20191108.111901.1376843696472234934.davem@davemloft.net>
To:     alexander.sverdlin@nokia.com
Cc:     netdev@vger.kernel.org, jarod@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: octeon_mgmt: Account for second
 possible VLAN header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108.110921.1805146824772140727.davem@davemloft.net>
References: <20191107.151409.1123596566825003561.davem@davemloft.net>
        <20191108100024.126857-1-alexander.sverdlin@nokia.com>
        <20191108.110921.1805146824772140727.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 11:19:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 08 Nov 2019 11:09:21 -0800 (PST)

> From: "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
> Date: Fri, 8 Nov 2019 10:00:44 +0000
> 
>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>> 
>> Octeon's input ring-buffer entry has 14 bits-wide size field, so to account
>> for second possible VLAN header max_mtu must be further reduced.
>> 
>> Fixes: 109cc16526c6d ("ethernet/cavium: use core min/max MTU checking")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>> ---
>> Changelog:
>> v2: Added "Fixes:" tag, Cc'ed stable
> 
> Networking patches do not CC: stable, as per the Netdev FAQ

Applied with stable CC: removed, and queued up for -stable, thanks.
