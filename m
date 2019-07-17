Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867866C327
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbfGQW0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:26:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730031AbfGQW0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:26:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF3E714EC7274;
        Wed, 17 Jul 2019 15:26:33 -0700 (PDT)
Date:   Wed, 17 Jul 2019 15:26:33 -0700 (PDT)
Message-Id: <20190717.152633.681021760422039901.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@PaulSD.com, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: rt6_check should return NULL if 'from' is
 NULL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717220843.974-1-dsahern@kernel.org>
References: <20190717220843.974-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 15:26:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 17 Jul 2019 15:08:43 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Paul reported that l2tp sessions were broken after the commit referenced
> in the Fixes tag. Prior to this commit rt6_check returned NULL if the
> rt6_info 'from' was NULL - ie., the dst_entry was disconnected from a FIB
> entry. Restore that behavior.
> 
> Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> Reported-by: Paul Donohue <linux-kernel@PaulSD.com>
> Tested-by: Paul Donohue <linux-kernel@PaulSD.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks.
