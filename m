Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84754130AB2
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 00:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgAEXN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 18:13:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgAEXN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 18:13:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAF5615714151;
        Sun,  5 Jan 2020 15:13:26 -0800 (PST)
Date:   Sun, 05 Jan 2020 15:13:26 -0800 (PST)
Message-Id: <20200105.151326.1142785260688730914.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/3] Improvements to the DSA deferred xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200104003711.18366-1-olteanv@gmail.com>
References: <20200104003711.18366-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 15:13:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  4 Jan 2020 02:37:08 +0200

> After the feedback received on v1:
> https://www.spinics.net/lists/netdev/msg622617.html
> 
> I've decided to move the deferred xmit implementation completely within
> the sja1105 driver.
> 
> The executive summary for this series is the same as it was for v1
> (better for everybody):
> 
> - For those who don't use it, thanks to one less assignment in the
>   hotpath (and now also thanks to less code in the DSA core)
> - For those who do, by making its scheduling more amenable and moving it
>   outside the generic workqueue (since it still deals with packet
>   hotpath, after all)
> 
> There are some simplification (1/3) and cosmetic (3/3) patches in the
> areas next to the code touched by the main patch (2/3).

Series applied, thanks.
