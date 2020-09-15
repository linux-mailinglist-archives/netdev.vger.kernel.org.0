Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1290126B1A0
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgIOWd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbgIOQQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 12:16:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B697620872;
        Tue, 15 Sep 2020 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600185890;
        bh=AEtxiKHpeygtSNY02mrYexQV+Cnr3UEJaAUcLR8vWVk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0DmR6DDVI2k0jofBKKk1BCpDtfJMq6vMOcYRjK4OoJyg61BG8+D+YxTRUiGcpTaMZ
         wR8Vh+A83y3HnLKn0QCtfmgasEhOj0Rppt5n8/LsVCyG88yWWyOfKtRaNyRrp5Hdcz
         CDLrNZqTeQOScBt+Y3vUpiw2NMzAyromMw+5miww=
Date:   Tue, 15 Sep 2020 09:04:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 15/15] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
Message-ID: <20200915090448.38b115d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600063682-17313-16-git-send-email-moshe@mellanox.com>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
        <1600063682-17313-16-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 09:08:02 +0300 Moshe Shemesh wrote:
> +   * - ``no_reset``
> +     - No reset allowed, no down time allowed, no link flap and no
> +       configuration is lost.

It still takes the PCI link down for up to 2sec. So there is down time,
right?
