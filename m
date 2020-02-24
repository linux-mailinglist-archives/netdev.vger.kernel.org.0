Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB9C16B482
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgBXWsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:48:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39680 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXWsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 17:48:36 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFFCA1235831F;
        Mon, 24 Feb 2020 14:47:29 -0800 (PST)
Date:   Mon, 24 Feb 2020 14:47:14 -0800 (PST)
Message-Id: <20200224.144714.329725174070305071.davem@davemloft.net>
To:     vicamo.yang@canonical.com
Cc:     hayeswang@realtek.com, kuba@kernel.org, pmalani@chromium.org,
        kai.heng.feng@canonical.com, grundler@chromium.org,
        vicamo@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: r8151: check disconnect status after long sleep
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224071541.117363-1-vicamo.yang@canonical.com>
References: <20200224071541.117363-1-vicamo.yang@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 14:48:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: You-Sheng Yang <vicamo.yang@canonical.com>
Date: Mon, 24 Feb 2020 15:15:41 +0800

> When hotplugging such dock with additional usb devices already attached on
> it, the probing process may reset usb 2.1 port, therefore r8152 ethernet
> device is also reset. However, during r8152 device init there are several
> for-loops that, when it's unable to retrieve hardware registers due to
> being discconected from USB, may take up to 14 seconds each in practice,
> and that has to be completed before USB may re-enumerate devices on the
> bus. As a result, devices attached to the dock will only be available
> after nearly 1 minute after the dock was plugged in:

Your description of the problem and exactly what is happening is great,
but you are not explaining how exactly you are solving the problem and
why you are solving it in that way.

Please enhance your commit message the explain those things.

Thank you.
