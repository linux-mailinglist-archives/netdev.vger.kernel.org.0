Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AB221D86
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfEQSjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:39:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEQSjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:39:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 434B613F18502;
        Fri, 17 May 2019 11:39:36 -0700 (PDT)
Date:   Fri, 17 May 2019 11:39:24 -0700 (PDT)
Message-Id: <20190517.113924.1441508070379690525.davem@davemloft.net>
To:     swkhack@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: caif: fix the value of size argument of snprintf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190517075922.29123-1-swkhack@gmail.com>
References: <20190517075922.29123-1-swkhack@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 11:39:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weikang shi <swkhack@gmail.com>
Date: Fri, 17 May 2019 15:59:22 +0800

> From: swkhack <swkhack@gmail.com>
> 
> Because the function snprintf write at most size bytes(including the
> null byte).So the value of the argument size need not to minus one.
> 
> Signed-off-by: swkhack <swkhack@gmail.com>

Applied.
