Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB8216B091
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgBXTt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:49:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBXTt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:49:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1700120F5DF5;
        Mon, 24 Feb 2020 11:49:55 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:49:52 -0800 (PST)
Message-Id: <20200224.114952.1670161895162956201.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, thomas.lendacky@amd.com,
        keyur@os.amperecomputing.com, pcnet32@frontier.com,
        vfalico@gmail.com, j.vosburgh@gmail.com, linux-acenic@sunsite.dk,
        mripard@kernel.org, heiko@sntech.de, mark.einon@gmail.com,
        chris.snook@gmail.com, linux-rockchip@lists.infradead.org,
        iyappan@os.amperecomputing.com, irusskikh@marvell.com,
        dave@thedillows.org, netanel@amazon.com,
        quan@os.amperecomputing.com, jcliburn@gmail.com,
        LinoSanfilippo@gmx.de, linux-arm-kernel@lists.infradead.org,
        andreas@gaisler.com, andy@greyhouse.net, netdev@vger.kernel.org,
        thor.thayer@linux.intel.com, linux-kernel@vger.kernel.org,
        ionut@badula.org, akiyano@amazon.com, jes@trained-monkey.org,
        nios2-dev@lists.rocketboards.org, wens@csie.org
Subject: Re: [PATCH net-next v1 00/18] Clean driver, module and FW versions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200224085311.460338-1-leon@kernel.org>
References: <20200224085311.460338-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 11:49:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 24 Feb 2020 10:52:53 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Change log:
>  v1:
>   * Split all FW cleanups patches to separate patches
>   * Fixed commit message
>   * Deleted odd DRV_RELDATE
>   * Added everyone from MAINTAINERS file
>  v0: https://lore.kernel.org/netdev/20200220145855.255704-1-leon@kernel.org

Series applied, thanks Leon.
