Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646C3D49A6
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfJKVFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:05:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:05:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3CC314F6498F;
        Fri, 11 Oct 2019 14:05:42 -0700 (PDT)
Date:   Fri, 11 Oct 2019 14:05:40 -0700 (PDT)
Message-Id: <20191011.140540.2027562826793118009.davem@davemloft.net>
To:     dmitry.torokhov@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH 0/3] net: phy: switch to using fwnode_gpiod_get_index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011204242.GH229325@dtor-ws>
References: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
        <20191011204242.GH229325@dtor-ws>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 14:05:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Fri, 11 Oct 2019 13:42:42 -0700

> I see that the patches are marked as "Not applicable" in the netdev
> patchwork. Does this mean that you decided against pulling this
> immutable branch, or you dropped them because of kbuild complaints (that
> happened because it could not figure out how to apply the patches)?

I can't, because the dependencies don't exist in my tree.

So submit this into the tree that will have the dependencies.
