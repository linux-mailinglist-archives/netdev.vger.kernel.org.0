Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4626245032
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 01:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgHNXoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 19:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgHNXoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 19:44:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AF2C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 16:44:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F5B81277D40E;
        Fri, 14 Aug 2020 16:27:48 -0700 (PDT)
Date:   Fri, 14 Aug 2020 16:44:33 -0700 (PDT)
Message-Id: <20200814.164433.599312188037888620.davem@davemloft.net>
To:     nivedita.singhvi@canonical.com
Cc:     netdev@vger.kernel.org, jay.vosburgh@canonical.com
Subject: Re: [PATCH] docs: networking: bonding.rst resources section
 cleanup 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200813051005.6450-1-nivedita.singhvi@canonical.com>
References: <20200813051005.6450-1-nivedita.singhvi@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 16:27:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nivedita Singhvi <nivedita.singhvi@canonical.com>
Date: Thu, 13 Aug 2020 10:40:05 +0530

> Removed obsolete resources from bonding.rst doc:
>    - bonding-devel@lists.sourceforge.net hasn't been used since 2008
>    - admin interface is 404
>    - Donald Becker's domain/content no longer online
> 
> Signed-off-by: Nivedita Singhvi <nivedita.singhvi@canonical.com>

Applied, thanks.
