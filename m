Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B7D7D58
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbfJORUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:20:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfJORUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:20:15 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2146115043D43;
        Tue, 15 Oct 2019 10:20:14 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:20:13 -0400 (EDT)
Message-Id: <20191015.132013.246221433893437093.davem@davemloft.net>
To:     taoren@fb.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        olteanv@gmail.com, arun.parameswaran@broadcom.com,
        justinpopo6@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <61e33434-c315-b80a-68bc-f0fe8f5029e7@fb.com>
References: <20190909204906.2191290-1-taoren@fb.com>
        <20190914141752.GC27922@lunn.ch>
        <61e33434-c315-b80a-68bc-f0fe8f5029e7@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 10:20:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <taoren@fb.com>
Date: Tue, 15 Oct 2019 17:16:26 +0000

> Can you please apply the patch series to net-next tree when you have
> bandwidth? All the 3 patches are reviewed.

If it is not active in patchwork you need to repost.
