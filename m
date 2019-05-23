Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA9C27394
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfEWAzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:55:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWAzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:55:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 152351457787C;
        Wed, 22 May 2019 17:55:48 -0700 (PDT)
Date:   Wed, 22 May 2019 17:55:47 -0700 (PDT)
Message-Id: <20190522.175547.1823430003257694990.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] net: Set strict_start_type for routes and
 rules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522190743.15583-1-dsahern@kernel.org>
References: <20190522190743.15583-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:55:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 May 2019 12:07:43 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> New userspace on an older kernel can send unknown and unsupported
> attributes resulting in an incompelete config which is almost
> always wrong for routing (few exceptions are passthrough settings
> like the protocol that installed the route).
> 
> Set strict_start_type in the policies for IPv4 and IPv6 routes and
> rules to detect new, unsupported attributes and fail the route add.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
