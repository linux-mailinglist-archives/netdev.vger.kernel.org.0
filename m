Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA8BCC4C6
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387967AbfJDV0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:26:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387690AbfJDV0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:26:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98DA814F0FA93;
        Fri,  4 Oct 2019 14:26:15 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:26:15 -0700 (PDT)
Message-Id: <20191004.142615.229986496137985788.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: spread "enum sock_flags"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003205637.GA24270@avx2>
References: <20191003205637.GA24270@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:26:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 3 Oct 2019 23:56:37 +0300

> Some ints are "enum sock_flags" in fact.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied.
