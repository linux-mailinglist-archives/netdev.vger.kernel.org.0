Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B3E117380
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfLISKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:10:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:10:07 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 772711543992E;
        Mon,  9 Dec 2019 10:10:06 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:10:05 -0800 (PST)
Message-Id: <20191209.101005.1980841296607612612.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        bunk@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com
Subject: Re: [PATCH net-next v2 0/2] Rebase of patches
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209175943.23110-1-dmurphy@ti.com>
References: <20191209175943.23110-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:10:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Mon, 9 Dec 2019 11:59:41 -0600

> This is a rebase of the dp83867 patches on top of the net-next tree

That's not what this patch series does.

The introductory posting is where you describe, at a high level, what the
whole patch series is doing as a unit, how it is doing it, and why it is
doing it that way.

It also serves as the single email I can respond to when I want to let you
know that I've applied the patch series.

Please read the documentation under Documentation/ if you still are unsure
what this introductory posting is all about and how you should compose one.

Thank you.
