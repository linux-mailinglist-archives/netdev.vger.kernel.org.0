Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3B93AD63
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbfFJC7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:59:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFJC7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:59:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C56314EAF639;
        Sun,  9 Jun 2019 19:59:14 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:59:14 -0700 (PDT)
Message-Id: <20190609.195914.604099908354183520.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] Rethink PHYLINK callbacks for SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608130344.661-1-olteanv@gmail.com>
References: <20190608130344.661-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:59:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  8 Jun 2019 16:03:40 +0300

> This patchset implements phylink_mac_link_up and phylink_mac_link_down,
> while also removing the code that was modifying the EGRESS and INGRESS
> MAC settings for STP and replacing them with the "inhibit TX"
> functionality.

Series applied, thanks.
