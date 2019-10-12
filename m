Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB0FD4C86
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 05:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfJLDps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 23:45:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLDps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 23:45:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 067CA150030AC;
        Fri, 11 Oct 2019 20:45:47 -0700 (PDT)
Date:   Fri, 11 Oct 2019 20:45:47 -0700 (PDT)
Message-Id: <20191011.204547.362684384666618017.davem@davemloft.net>
To:     vcaputo@pengaru.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sock_get_timeout: drop unnecessary return variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010040824.fbauijiiyyz5dl5y@shells.gnugeneration.com>
References: <20191010040824.fbauijiiyyz5dl5y@shells.gnugeneration.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 20:45:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vito Caputo <vcaputo@pengaru.com>
Date: Wed, 9 Oct 2019 21:08:24 -0700

> Remove pointless use of size return variable by directly returning
> sizes.
> 
> Signed-off-by: Vito Caputo <vcaputo@pengaru.com>

Looks good, applied to net-next.
