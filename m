Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA21F149579
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 13:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgAYMTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 07:19:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAYMTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 07:19:03 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B89715B11750;
        Sat, 25 Jan 2020 04:19:01 -0800 (PST)
Date:   Sat, 25 Jan 2020 13:18:59 +0100 (CET)
Message-Id: <20200125.131859.1794787963209229331.davem@davemloft.net>
To:     amaftei@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        scrum-linux@solarflare.com
Subject: Re: [PATCH v2 net-next 0/3] sfc: refactor mcdi filtering code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
References: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 04:19:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Date: Fri, 24 Jan 2020 16:33:21 +0000

> Splitting final bits of the driver code into different files, which
> will later be used in another driver for a new product.
> 
> This is a continuation to my previous patch series. (three of them)
> Refactoring will be concluded with this series, for now.
> 
> As instructed, split the renaming and moving into different patches.
> Minor refactoring was done with the renaming, as explained in the
> patch.

'git' complains when I try to apply this series, please fix and respin.

Applying: sfc: rename mcdi filtering functions/structs
.git/rebase-apply/patch:651: space before tab in indent.
			     	    enum efx_filter_priority priority,
.git/rebase-apply/patch:652: space before tab in indent.
			     	    u32 filter_id, struct efx_filter_spec *spec)
.git/rebase-apply/patch:677: space before tab in indent.
			     	    enum efx_filter_priority priority)
warning: 3 lines add whitespace errors.
Applying: sfc: create header for mcdi filtering code
Applying: sfc: move mcdi filtering code
