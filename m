Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4582122A3F4
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387434AbgGWA5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWA5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:57:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7684EC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:57:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37CB0126ABE80;
        Wed, 22 Jul 2020 17:41:05 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:57:49 -0700 (PDT)
Message-Id: <20200722.175749.2262678023965125909.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next] mptcp: zero token hash at creation time.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9c1619337f0fa54112c0fe6f0e0100ded392ac3e.1595431172.git.pabeni@redhat.com>
References: <9c1619337f0fa54112c0fe6f0e0100ded392ac3e.1595431172.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:41:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 22 Jul 2020 17:20:50 +0200

> Otherwise the 'chain_len' filed will carry random values,
> some token creation calls will fail due to excessive chain
> length, causing unexpected fallback to TCP.
> 
> Fixes: 2c5ebd001d4f ("mptcp: refactor token container")
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Tested-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks Paolo.
