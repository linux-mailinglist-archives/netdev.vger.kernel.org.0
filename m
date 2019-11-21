Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9720F105CD2
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 23:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfKUWqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 17:46:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUWqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 17:46:10 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52D3C150A931F;
        Thu, 21 Nov 2019 14:46:10 -0800 (PST)
Date:   Thu, 21 Nov 2019 14:46:09 -0800 (PST)
Message-Id: <20191121.144609.2224010348137082063.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ecree@solarflare.com, dsahern@gmail.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next v4 0/5] net: introduce and use route hint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1574252982.git.pabeni@redhat.com>
References: <cover.1574252982.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 14:46:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 20 Nov 2019 13:47:32 +0100

> This series leverages the listification infrastructure to avoid
> unnecessary route lookup on ingress packets. In absence of custom rules,
> packets with equal daddr will usually land on the same dst.
> 
> When processing packet bursts (lists) we can easily reference the previous
> dst entry. When we hit the 'same destination' condition we can avoid the
> route lookup, coping the already available dst.
> 
> Detailed performance numbers are available in the individual commit
> messages.
 ...

Series applied, thanks.

