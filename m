Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFD146332
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfFNPpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:45:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfFNPpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:45:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D07214B2A351;
        Fri, 14 Jun 2019 08:45:23 -0700 (PDT)
Date:   Fri, 14 Jun 2019 08:45:23 -0700 (PDT)
Message-Id: <20190614.084523.409954717487562128.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     g.nault@alphalink.fr, netdev@vger.kernel.org
Subject: Re: [PATCH] l2tp: no need to check return value of debugfs_create
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614070438.GA25351@kroah.com>
References: <20190614070438.GA25351@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 08:45:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 14 Jun 2019 09:04:38 +0200

> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Also, there is no need to store the individual debugfs file name, just
> remove the whole directory all at once, saving a local variable.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Guillaume Nault <g.nault@alphalink.fr>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied.
