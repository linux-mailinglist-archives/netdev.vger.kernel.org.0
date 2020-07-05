Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E037C215033
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgGEWcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgGEWcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:32:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D71C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:32:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA212128FAD2A;
        Sun,  5 Jul 2020 15:32:18 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:32:17 -0700 (PDT)
Message-Id: <20200705.153217.1439206614034376381.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next 0/5] net: dsa: Fix C=1 W=1 warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705193008.889623-1-andrew@lunn.ch>
References: <20200705193008.889623-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:32:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun,  5 Jul 2020 21:30:03 +0200

> Mostly not using __be16 when decoding packet contents.

Series applied with patch #1's subject fixed.
