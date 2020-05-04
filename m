Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8863B1C42CA
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgEDRae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729549AbgEDRae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:30:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413B6C061A0E;
        Mon,  4 May 2020 10:30:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FD2A119534EF;
        Mon,  4 May 2020 10:30:31 -0700 (PDT)
Date:   Mon, 04 May 2020 10:30:27 -0700 (PDT)
Message-Id: <20200504.103027.1573174382777601889.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: Do not make user port errors fatal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504035057.20275-1-f.fainelli@gmail.com>
References: <20200504035057.20275-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:30:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun,  3 May 2020 20:50:57 -0700

> Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
> not treat failures to set-up an user port as fatal, but after this
> commit we would, which is a regression for some systems where interfaces
> may be declared in the Device Tree, but the underlying hardware may not
> be present (pluggable daughter cards for instance).
> 
> Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks Florian.
