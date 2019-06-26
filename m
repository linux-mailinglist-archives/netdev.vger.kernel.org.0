Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF7B57267
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfFZUPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:15:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:15:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B80314DB838A;
        Wed, 26 Jun 2019 13:15:18 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:15:17 -0700 (PDT)
Message-Id: <20190626.131517.2250880531223680323.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] rtnetlink: skip metrics loop for
 dst_default_metrics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621232716.26755-1-dsahern@kernel.org>
References: <20190621232716.26755-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:15:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri, 21 Jun 2019 16:27:16 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> dst_default_metrics has all of the metrics initialized to 0, so nothing
> will be added to the skb in rtnetlink_put_metrics. Avoid the loop if
> metrics is from dst_default_metrics.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
