Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83368105A94
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKUTsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:48:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52430 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:48:33 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2747A15043D4B;
        Thu, 21 Nov 2019 11:48:33 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:48:32 -0800 (PST)
Message-Id: <20191121.114832.1317783379308062647.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next] lwtunnel: be STRICT to validate the new
 LWTUNNEL_IP(6)_OPTS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1993c1c08a6e3e278afeb173e4f4584eea5e14aa.1574331087.git.lucien.xin@gmail.com>
References: <1993c1c08a6e3e278afeb173e4f4584eea5e14aa.1574331087.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:48:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 21 Nov 2019 18:11:27 +0800

> LWTUNNEL_IP(6)_OPTS are the new items in ip(6)_tun_policy, which
> are parsed by nla_parse_nested_deprecated(). We should check it
> strictly by setting .strict_start_type = LWTUNNEL_IP(6)_OPTS.
> 
> This patch also adds missing LWTUNNEL_IP6_OPTS in ip6_tun_policy.
> 
> Fixes: 4ece47787077 ("lwtunnel: add options setting and dumping for geneve")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
