Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D9947206
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfFOU0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:26:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39264 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOU0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:26:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8537314EB4B1C;
        Sat, 15 Jun 2019 13:26:02 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:25:55 -0700 (PDT)
Message-Id: <20190615.132555.265052877492424062.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: do not flood CPU with
 unknown multicast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612223344.28781-1-vivien.didelot@gmail.com>
References: <20190612223344.28781-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:26:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 12 Jun 2019 18:33:44 -0400

> The DSA ports must flood unknown unicast and multicast, but the switch
> must not flood the CPU ports with unknown multicast, as this results
> in a lot of undesirable traffic that the network stack needs to filter
> in software.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied.
