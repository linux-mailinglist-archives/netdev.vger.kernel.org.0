Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A53C1904A0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgCXEtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:49:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56352 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgCXEtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:49:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B97A157A55CC;
        Mon, 23 Mar 2020 21:49:16 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:49:16 -0700 (PDT)
Message-Id: <20200323.214916.478920434793489866.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, alobakin@dlink.ru, olteanv@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Implement flow dissection for
 tag_brcm.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200322210957.3940-1-f.fainelli@gmail.com>
References: <20200322210957.3940-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:49:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sun, 22 Mar 2020 14:09:57 -0700

> Provide a flow_dissect callback which returns the network offset and
> where to find the skb protocol, given the tags structure a common
> function works for both tagging formats that are supported.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks Florian.
