Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37F56292A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbfGHTRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:17:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfGHTRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:17:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C2534133E98D7;
        Mon,  8 Jul 2019 12:17:14 -0700 (PDT)
Date:   Mon, 08 Jul 2019 12:17:14 -0700 (PDT)
Message-Id: <20190708.121714.1981715032297079132.davem@davemloft.net>
To:     mhabets@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: Remove 'PCIE error reporting unavailable'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156258403191.17195.13184667600147687856.stgit@mh-desktop.uk.solarflarecom.com>
References: <156258403191.17195.13184667600147687856.stgit@mh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 12:17:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <mhabets@solarflare.com>
Date: Mon, 8 Jul 2019 12:07:11 +0100

> This is only at notice level but it was pointed out that no other driver
> does this.
> Also there is no action the user can take as it is really a property of
> the server.
> 
> Signed-off-by: Martin Habets <mhabets@solarflare.com>

Applied, thanks.
