Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E7E2450B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfEUAYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:24:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfEUAYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:24:06 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3764613FE9803;
        Mon, 20 May 2019 17:24:06 -0700 (PDT)
Date:   Mon, 20 May 2019 20:24:05 -0400 (EDT)
Message-Id: <20190520.202405.878127029707426686.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, po.liu@nxp.com
Subject: Re: [PATCH net-next] ptp: Fix example program to match kernel.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520051505.17412-1-richardcochran@gmail.com>
References: <20190520051505.17412-1-richardcochran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:24:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sun, 19 May 2019 22:15:05 -0700

> Ever since commit 3a06c7ac24f9 ("posix-clocks: Remove interval timer
> facility and mmap/fasync callbacks") the possibility of PHC based
> posix timers has been removed.  In addition it will probably never
> make sense to implement this functionality.
> 
> This patch removes the misleading example code which seems to suggest
> that posix timers for PHC devices will ever be a thing.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks.
