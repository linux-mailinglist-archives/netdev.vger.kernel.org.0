Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F46521503E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgGEWsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgGEWsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:48:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64817C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:48:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB76F12915D7B;
        Sun,  5 Jul 2020 15:48:40 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:48:40 -0700 (PDT)
Message-Id: <20200705.154840.809662783837103276.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        privat@egil-hjelmeland.no
Subject: Re: [PATCH] net: dsa: lan9303: fix variable 'res' set but not used
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705205555.893062-1-andrew@lunn.ch>
References: <20200705205555.893062-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:48:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun,  5 Jul 2020 22:55:55 +0200

> Since lan9303_adjust_link() is a void function, there is no option to
> return an error. So just remove the variable and lets any errors be
> discarded.
> 
> Cc: Egil Hjelmeland <privat@egil-hjelmeland.no>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied to net-next.
