Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E75117440
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfLISbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:31:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfLISbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:31:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDB8415434E25;
        Mon,  9 Dec 2019 10:31:19 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:31:19 -0800 (PST)
Message-Id: <20191209.103119.563197602023949500.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        bunk@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com
Subject: Re: [PATCH net-next v2 0/2] Rebase of patches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <898c9346-311e-4c93-9f83-afe255b54243@ti.com>
References: <20191209175943.23110-1-dmurphy@ti.com>
        <20191209.101005.1980841296607612612.davem@davemloft.net>
        <898c9346-311e-4c93-9f83-afe255b54243@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:31:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Mon, 9 Dec 2019 12:23:46 -0600

> I understand what a cover letter is.

As seen below, perhaps you don't

> The commit messages should explain in detail
> what is being changed as the cover letters are not committed to the
> kernel.

Not true.

I _always_ add them, for every networking patch series.

They go into the merge commit I create for your patch series.
