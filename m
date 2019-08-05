Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48CB825ED
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfHEUSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:18:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33652 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:18:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E752B1542DA9D;
        Mon,  5 Aug 2019 13:18:09 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:18:09 -0700 (PDT)
Message-Id: <20190805.131809.2116167655536123837.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] ipv6: have a single rcu unlock point in
 __ip6_rt_update_pmtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801221808.18321-1-dsahern@kernel.org>
References: <20190801221808.18321-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:18:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  1 Aug 2019 15:18:08 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Simplify the unlock path in __ip6_rt_update_pmtu by using a
> single point where rcu_read_unlock is called.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
