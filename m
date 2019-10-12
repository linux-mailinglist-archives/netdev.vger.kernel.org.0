Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F065D4C81
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 05:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfJLDk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 23:40:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfJLDk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 23:40:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE81C15003084;
        Fri, 11 Oct 2019 20:40:56 -0700 (PDT)
Date:   Fri, 11 Oct 2019 20:40:56 -0700 (PDT)
Message-Id: <20191011.204056.74629495407810105.davem@davemloft.net>
To:     vcaputo@pengaru.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_unix: __unix_find_socket_byname() cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010034347.ohjmoivd7f426znd@shells.gnugeneration.com>
References: <20191010034347.ohjmoivd7f426znd@shells.gnugeneration.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 20:40:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vito Caputo <vcaputo@pengaru.com>
Date: Wed, 9 Oct 2019 20:43:47 -0700

> Remove pointless return variable dance.
> 
> Appears vestigial from when the function did locking as seen in
> unix_find_socket_byinode(), but locking is handled in
> unix_find_socket_byname() for __unix_find_socket_byname().
> 
> Signed-off-by: Vito Caputo <vcaputo@pengaru.com>

I agree with your analysis. :-)

Applied to net-next.
