Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68881608E6
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgBQD2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:28:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgBQD2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:28:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 363B81573F03A;
        Sun, 16 Feb 2020 19:28:06 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:28:05 -0800 (PST)
Message-Id: <20200216.192805.2104578155326769364.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: bcm_sf2: Also configure Port 5 for
 2Gb/sec on 7278
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200215003230.27181-1-f.fainelli@gmail.com>
References: <20200215003230.27181-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:28:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 14 Feb 2020 16:32:29 -0800

> Either port 5 or port 8 can be used on a 7278 device, make sure that
> port 5 also gets configured properly for 2Gb/sec in that case.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
