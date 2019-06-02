Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE66324B9
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 22:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfFBUGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 16:06:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFBUGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 16:06:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D361F14010600;
        Sun,  2 Jun 2019 13:06:30 -0700 (PDT)
Date:   Sun, 02 Jun 2019 13:06:30 -0700 (PDT)
Message-Id: <20190602.130630.516000280894424300.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: Add test cases for nexthop objects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530190636.31664-1-dsahern@kernel.org>
References: <20190530190636.31664-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 13:06:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu, 30 May 2019 12:06:36 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Add functional test cases for nexthop objects.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks.
