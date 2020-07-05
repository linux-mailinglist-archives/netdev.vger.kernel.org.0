Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA9215037
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgGEWnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgGEWnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:43:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1120DC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:43:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F788128FCC71;
        Sun,  5 Jul 2020 15:43:17 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:43:16 -0700 (PDT)
Message-Id: <20200705.154316.255848763223783688.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/4] net: dsa: mv88e6xxx: Fixup C=1 W=1
 warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705193810.890020-1-andrew@lunn.ch>
References: <20200705193810.890020-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:43:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun,  5 Jul 2020 21:38:06 +0200

> Make the mv88e6xxx driver build cleanly with C=1 W=1.

Series applied, thanks.
