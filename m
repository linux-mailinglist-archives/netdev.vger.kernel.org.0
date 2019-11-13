Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FABFB8C2
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKMT0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:26:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfKMT0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:26:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1197E153DC531;
        Wed, 13 Nov 2019 11:26:46 -0800 (PST)
Date:   Wed, 13 Nov 2019 11:26:43 -0800 (PST)
Message-Id: <20191113.112643.1233449976904142046.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: pull request (net): ipsec 2019-11-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113112613.2596-1-steffen.klassert@secunet.com>
References: <20191113112613.2596-1-steffen.klassert@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Nov 2019 11:26:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Wed, 13 Nov 2019 12:26:11 +0100

> 1) Fix a page memleak on xfrm state destroy.
> 
> 2) Fix a refcount imbalance if a xfrm_state
>    gets invaild during async resumption.
>    From Xiaodong Xu.
> 
> Please pull or let me know if there are problems.

Pulled, thanks Steffen.
