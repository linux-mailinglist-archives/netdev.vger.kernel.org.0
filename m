Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE093194F4A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgC0C5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:57:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0C5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:57:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF06215CE71FB;
        Thu, 26 Mar 2020 19:57:19 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:57:19 -0700 (PDT)
Message-Id: <20200326.195719.255125842307862730.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/2] mv88e6xxx fixed link fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323214900.14083-1-andrew@lunn.ch>
References: <20200323214900.14083-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:57:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon, 23 Mar 2020 22:48:58 +0100

> Recent changes for how the MAC is configured broke fixed links, as
> used by CPU/DSA ports, and for SFPs when phylink cannot be used.

Please repost when you and Russell sort out the best way to handle the
fixed-link scenerio you described.

Thanks.
