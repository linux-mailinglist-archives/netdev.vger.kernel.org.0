Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5216B334C44
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhCJXNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:13:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44830 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhCJXNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 18:13:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BF39A4D0F5BAE;
        Wed, 10 Mar 2021 15:13:14 -0800 (PST)
Date:   Wed, 10 Mar 2021 15:13:10 -0800 (PST)
Message-Id: <20210310.151310.2000090857363909897.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     ciorneiioana@gmail.com, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com, jiri@resnulli.us,
        ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 00/15] dpaa2-switch: CPU terminated traffic
 and move out of staging
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YEjT6WL9jp3HCf+w@kroah.com>
References: <YEi/PlZLus2Ul63I@kroah.com>
        <20210310134744.cjong4pnrfxld4hf@skbuf>
        <YEjT6WL9jp3HCf+w@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 10 Mar 2021 15:13:15 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 10 Mar 2021 15:12:57 +0100

> Yes, either I can provide a stable tag to pull from for the netdev
> maintainers, or they can just add the whole driver to the "proper" place
> in the network tree and I can drop the one in staging entirely.  Or
> people can wait until 5.13-rc1 when this all shows up in Linus's tree,
> whatever works best for the networking maintainers, after reviewing it.

I've added this whole series to my tree as I think that makes things easiest
for everyone.

Thanks!
