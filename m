Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D255C21E467
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgGNAU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNAU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:20:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F484C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:20:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30FC012981391;
        Mon, 13 Jul 2020 17:20:58 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:20:57 -0700 (PDT)
Message-Id: <20200713.172057.15707472373442069.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/20] net simple kerneldoc fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:20:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 13 Jul 2020 01:14:56 +0200

> This is a collection of simple kerneldoc fixes. They are all low
> hanging fruit, were not real understanding of the code was needed.

Series applied, thanks Andrew.
