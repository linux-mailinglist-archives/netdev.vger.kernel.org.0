Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58137219089
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGHTcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgGHTcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:32:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1831FC061A0B;
        Wed,  8 Jul 2020 12:32:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84B271275C905;
        Wed,  8 Jul 2020 12:32:06 -0700 (PDT)
Date:   Wed, 08 Jul 2020 12:32:03 -0700 (PDT)
Message-Id: <20200708.123203.1079684608829711523.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com, dbezrukov@marvell.com,
        mstarovoitov@marvell.com, dbogdanov@marvell.com,
        epomozov@marvell.com, sergey.samoilenko@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: atlantic: fix ip dst and ipv6 address filters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708141710.758-1-alobakin@marvell.com>
References: <20200708141710.758-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 12:32:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Wed, 8 Jul 2020 17:17:10 +0300

> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> This patch fixes ip dst and ipv6 address filters.
> There were 2 mistakes in the code, which led to the issue:
> * invalid register was used for ipv4 dst address;
> * incorrect write order of dwords for ipv6 addresses.
> 
> Fixes: 23e7a718a49b ("net: aquantia: add rx-flow filter definitions")
> Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>

Applied and queued up for -stable, thanks.
