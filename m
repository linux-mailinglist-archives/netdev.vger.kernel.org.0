Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D60217B16
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgGGWjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGGWjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:39:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBAEC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:39:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98274120F19EC;
        Tue,  7 Jul 2020 15:39:51 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:39:51 -0700 (PDT)
Message-Id: <20200707.153951.1823043531558071786.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH -next] Documentation: networking: fix ethtool-netlink
 table formats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <10c2e583-af4a-7f06-b3d0-79fbec0ebfd6@infradead.org>
References: <10c2e583-af4a-7f06-b3d0-79fbec0ebfd6@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:39:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 5 Jul 2020 19:55:44 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix table formatting to eliminate warnings.
> 
> Documentation/networking/ethtool-netlink.rst:509: WARNING: Malformed table.
> Documentation/networking/ethtool-netlink.rst:522: WARNING: Malformed table.
> Documentation/networking/ethtool-netlink.rst:543: WARNING: Malformed table.
> Documentation/networking/ethtool-netlink.rst:555: WARNING: Malformed table.
> Documentation/networking/ethtool-netlink.rst:591: WARNING: Malformed table.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks.
