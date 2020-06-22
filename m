Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9F62040CB
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgFVUCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgFVUCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:02:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13890C0617BC
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 12:56:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D62D41295B24F;
        Mon, 22 Jun 2020 12:56:22 -0700 (PDT)
Date:   Mon, 22 Jun 2020 12:56:19 -0700 (PDT)
Message-Id: <20200622.125619.1308273787831695141.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     nbd@nbd.name, kuba@kernel.org, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: remove Felix Fietkau for the Mediatek
 ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621144436.GJ1605@shell.armlinux.org.uk>
References: <20200218120036.380a5a16@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <6ec21622-f9fe-8cf9-0464-7f5e4bb0a47e@nbd.name>
        <20200621144436.GJ1605@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 12:56:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Sun, 21 Jun 2020 15:44:37 +0100

> And _still_, in next-next, four months on, your MAINTAINERS entry is
> still incorrect.
> 
> Can someone please merge my patch so I'm not confronted by bounces
> due to this incorrect entry?  I really don't see why I should be
> the one to provide a patch to correct Felix's address - that's for
> Felix himself to do, especially as he has already been made aware
> of the issue.

Russell, in situations like this just resubmit the patch to the list.

I never go into the past and apply things that already cycled through
patchwork or similar.

Thanks.
