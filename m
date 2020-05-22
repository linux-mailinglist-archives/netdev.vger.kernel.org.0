Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18ABC1DDC21
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgEVAZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgEVAZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:25:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584AFC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 17:25:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B420A120ED486;
        Thu, 21 May 2020 17:25:26 -0700 (PDT)
Date:   Thu, 21 May 2020 17:25:25 -0700 (PDT)
Message-Id: <20200521.172525.2272564587463872419.davem@davemloft.net>
To:     vfedorenko@novek.ru
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net] net: ipip: fix wrong address family in init error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589964648-12516-1-git-send-email-vfedorenko@novek.ru>
References: <1589964648-12516-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:25:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>
Date: Wed, 20 May 2020 11:50:48 +0300

> In case of error with MPLS support the code is misusing AF_INET
> instead of AF_MPLS.
> 
> Fixes: 1b69e7e6c4da ("ipip: support MPLS over IPv4")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Applied and queued up for -stable, thanks.
