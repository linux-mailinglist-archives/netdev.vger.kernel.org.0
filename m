Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36396615B
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfGKVnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:43:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47338 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfGKVnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:43:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F41314DB02C0;
        Thu, 11 Jul 2019 14:43:41 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:43:41 -0700 (PDT)
Message-Id: <20190711.144341.734081163012422910.davem@davemloft.net>
To:     xingwu.yang@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] ipv6: Use ipv6_authlen for len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710131410.75825-1-xingwu.yang@gmail.com>
References: <20190710131410.75825-1-xingwu.yang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:43:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>
Date: Wed, 10 Jul 2019 21:14:10 +0800

> The length of AH header is computed manually as (hp->hdrlen+2)<<2.
> However, in include/linux/ipv6.h, a macro named ipv6_authlen is
> already defined for exactly the same job. This commit replaces
> the manual computation code with the macro.
> 
> Signed-off-by: yangxingwu <xingwu.yang@gmail.com>

Applied.
