Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659FC1904B9
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgCXE6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:58:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgCXE6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:58:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E20C8157D8A4F;
        Mon, 23 Mar 2020 21:58:04 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:58:04 -0700 (PDT)
Message-Id: <20200323.215804.1954283596047238734.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Remove DST_HOST
From:   David Miller <davem@davemloft.net>
In-Reply-To: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
References: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:58:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 23 Mar 2020 14:31:19 +0000

> Previous changes to the IP routing code have removed all the
> tests for the DS_HOST route flag.
> Remove the flags and all the code that sets it.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>

Applied, thanks.

> NB this may need rebasing.

It wasn't too bad.
