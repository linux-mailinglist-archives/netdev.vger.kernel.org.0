Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264CD16333C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgBRUl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:41:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36978 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRUl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:41:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4B9312357EB3;
        Tue, 18 Feb 2020 12:41:57 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:41:57 -0800 (PST)
Message-Id: <20200218.124157.111814567105514802.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org,
        Jason@zx2c4.com
Subject: Re: [PATCH net-next] sfc: elide assignment of skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <85e28e89-0488-c7e2-8ea4-3feaeada22a4@solarflare.com>
References: <85e28e89-0488-c7e2-8ea4-3feaeada22a4@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:41:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 18 Feb 2020 17:34:00 +0000

> Instead of assigning skb = segments before the loop, just pass
>  segments directly as the first argument to skb_list_walk_safe().
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied.
