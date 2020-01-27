Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DE214A387
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgA0MLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:11:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730448AbgA0MLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:11:12 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD9C1153048F6;
        Mon, 27 Jan 2020 04:11:10 -0800 (PST)
Date:   Mon, 27 Jan 2020 13:11:06 +0100 (CET)
Message-Id: <20200127.131106.710703577269207731.davem@davemloft.net>
To:     amaftei@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        scrum-linux@solarflare.com
Subject: Re: [PATCH v3 net-next 0/3] sfc: refactor mcdi filtering code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <62445381-c3f7-1f10-897f-4990da13aa0b@solarflare.com>
References: <62445381-c3f7-1f10-897f-4990da13aa0b@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 04:11:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Date: Mon, 27 Jan 2020 11:12:01 +0000

> Splitting final bits of the driver code into different files, which
> will later be used in another driver for a new product.
> 
> This is a continuation to my previous patch series. (three of them)
> Refactoring will be concluded with this series, for now.
> 
> As instructed, split the renaming and moving into different patches.
> Removed stray spaces before tabs... twice.
> Minor refactoring was done with the renaming, as explained in the
> first patch.

Series applied, thank you.
