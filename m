Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577EC123FC7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLRGkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:40:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47368 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLRGkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:40:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 258F41500C698;
        Tue, 17 Dec 2019 22:40:52 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:40:51 -0800 (PST)
Message-Id: <20191217.224051.85490096962356922.davem@davemloft.net>
To:     ben.dooks@codethink.co.uk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: make unexported dsa_link_touch() static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217112038.2069386-1-ben.dooks@codethink.co.uk>
References: <20191217112038.2069386-1-ben.dooks@codethink.co.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:40:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Date: Tue, 17 Dec 2019 11:20:38 +0000

> dsa_link_touch() is not exported, or defined outside of the
> file it is in so make it static to avoid the following warning:
> 
> net/dsa/dsa2.c:127:17: warning: symbol 'dsa_link_touch' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

Applied.
