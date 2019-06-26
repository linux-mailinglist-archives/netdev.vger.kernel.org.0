Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACD457290
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZU0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:26:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41182 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZU0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:26:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8353114DB847D;
        Wed, 26 Jun 2019 13:26:35 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:26:34 -0700 (PDT)
Message-Id: <20190626.132634.1369555115978417142.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, ndesaulniers@google.com
Subject: Re: [PATCH net v2 0/2] ipv6: fix neighbour resolution with raw
 socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624140109.14775-1-nicolas.dichtel@6wind.com>
References: <20190622.170816.1879839685931480272.davem@davemloft.net>
        <20190624140109.14775-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:26:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 24 Jun 2019 16:01:07 +0200

> The first patch prepares the fix, it constify rt6_nexthop().
> The detail of the bug is explained in the second patch.
> 
> v1 -> v2:
>  - fix compilation warnings
>  - split the initial patch

Series applied, thanks Nicolas.
