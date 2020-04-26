Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4726B1B8BB3
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgDZDlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgDZDlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:41:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BD3C061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 20:41:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10E02159FD9F0;
        Sat, 25 Apr 2020 20:41:23 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:41:22 -0700 (PDT)
Message-Id: <20200425.204122.1664382749674695754.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] hsr: remove unnecessary code in
 hsr_dev_change_mtu()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424124309.29931-1-ap420073@gmail.com>
References: <20200424124309.29931-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:41:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 24 Apr 2020 12:43:09 +0000

> In the hsr_dev_change_mtu(), the 'dev' and 'master->dev' pointer are
> same. So, the 'master' variable and some code are unnecessary.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied.
