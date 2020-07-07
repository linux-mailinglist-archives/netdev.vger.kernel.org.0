Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091FF217835
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgGGTr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbgGGTr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:47:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD61C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:47:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04B82120F19EC;
        Tue,  7 Jul 2020 12:47:25 -0700 (PDT)
Date:   Tue, 07 Jul 2020 12:47:24 -0700 (PDT)
Message-Id: <20200707.124724.245613624074314448.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 0/7] drivers/net/phy C=1 W=1 fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707014939.938621-1-andrew@lunn.ch>
References: <20200707014939.938621-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 12:47:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue,  7 Jul 2020 03:49:32 +0200

> This fixes most of the Sparse and W=1 warnings in drivers/net/phy. The
> Cavium code is still not fully clean, but it might actually be the
> strange code is confusing Sparse.
> 
> v2
> --
> Added RB, TB, AB.
> s/case/cause
> Reverse Christmas tree
> Module soft dependencies

Series applied, thanks Andrew.
