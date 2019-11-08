Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23A9F3E9A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfKHDzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:55:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfKHDzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:55:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65C3D14F2001D;
        Thu,  7 Nov 2019 19:55:04 -0800 (PST)
Date:   Thu, 07 Nov 2019 19:55:03 -0800 (PST)
Message-Id: <20191107.195503.1153287079198572860.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/12] Aquantia Marvell atlantic driver
 updates 11-2019
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1573158381.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 19:55:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Thu, 7 Nov 2019 22:41:47 +0000

> Here is a bunch of atlantic driver new features and updates.
> 
> Shortlist:
> - Me adding ethtool private flags for various loopback test modes,
> - Nikita is doing some work here on power management, implementing new PM API,
>   He also did some checkpatch style cleanup of older driver parts.
> - I'm also adding a new UDP GSO offload support and flags for loopback activation
> - We are now Marvell, so I am changing email addresses on maintainers list.
> 
> v2: styling, ip6 correct handling in udpgso

Series applied, thanks.
