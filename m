Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F5D1D8C68
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgESAgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgESAgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:36:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EFDC061A0C;
        Mon, 18 May 2020 17:36:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C634712765131;
        Mon, 18 May 2020 17:36:05 -0700 (PDT)
Date:   Mon, 18 May 2020 17:36:05 -0700 (PDT)
Message-Id: <20200518.173605.1537897116194958261.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipv6: symbol_get to access a sit symbol
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518063043.GA19046@lst.de>
References: <20200515063324.GA31377@lst.de>
        <20200516.135548.2079608042651975047.davem@davemloft.net>
        <20200518063043.GA19046@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:36:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Mon, 18 May 2020 08:30:43 +0200

> I'll look into implenenting the tunnel_ctl method just for kernel
> callers (plus maybe a generic helper for the ioctl), and we'll see if
> you like that better.

Ok, thank you.
