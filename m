Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C0814186
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfEERdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:33:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEERdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:33:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58E2014DA6480;
        Sun,  5 May 2019 10:33:53 -0700 (PDT)
Date:   Sun, 05 May 2019 10:33:52 -0700 (PDT)
Message-Id: <20190505.103352.552893412554706513.davem@davemloft.net>
To:     christophe.leroy@c-s.fr
Cc:     leoyang.li@nxp.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ucc_geth - fix Oops when changing number of
 buffers in the ring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ba66f38ff44b95e82925fd0500eb32fe03895496.1556889892.git.christophe.leroy@c-s.fr>
References: <ba66f38ff44b95e82925fd0500eb32fe03895496.1556889892.git.christophe.leroy@c-s.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:33:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Fri,  3 May 2019 13:33:23 +0000 (UTC)

> When changing the number of buffers in the RX ring while the interface
> is running, the following Oops is encountered due to the new number
> of buffers being taken into account immediately while their allocation
> is done when opening the device only.
 ...
> This patch forbids the modification of the number of buffers in the
> ring while the interface is running.
> 
> Fixes: ac421852b3a0 ("ucc_geth: add ethtool support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Applied and queued up for -stable.
