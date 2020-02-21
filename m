Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E407E1682F7
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgBUQN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:13:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgBUQN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 11:13:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CD9A158261B7;
        Fri, 21 Feb 2020 08:13:56 -0800 (PST)
Date:   Fri, 21 Feb 2020 08:13:52 -0800 (PST)
Message-Id: <20200221.081352.1754931534360921628.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     brouer@redhat.com, netdev@vger.kernel.org, lorenzo@kernel.org,
        rdunlap@infradead.org, toke@redhat.com
Subject: Re: [PATCH net-next v3] net: page_pool: Add documentation on
 page_pool API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221091519.916438-1-ilias.apalodimas@linaro.org>
References: <20200221091519.916438-1-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 08:13:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Fri, 21 Feb 2020 11:15:19 +0200

> Add documentation explaining the basic functionality and design
> principles of the API
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
> Changes since:
> v1:
> - Rephrase sentences that didn't make sense (Randy)
> - Removed trailing whitespaces (Randy)
> v2:
> - Changed order^n pages description to 2^order which is the correct description
>  for the lage allocator (Randy)

Applied, thank you.
