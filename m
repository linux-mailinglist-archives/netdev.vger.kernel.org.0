Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14221503B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGEWqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgGEWqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 18:46:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532F9C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 15:46:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6346129121AD;
        Sun,  5 Jul 2020 15:46:02 -0700 (PDT)
Date:   Sun, 05 Jul 2020 15:46:01 -0700 (PDT)
Message-Id: <20200705.154601.1297534332337267733.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 0/3] dsa: b53/sf2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200705203625.891900-1-andrew@lunn.ch>
References: <20200705203625.891900-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jul 2020 15:46:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun,  5 Jul 2020 22:36:22 +0200

> Fixup most of the C=1 W=1 warnings in these drivers.

Series applied with patch #1 and #2's subjects fixed.
