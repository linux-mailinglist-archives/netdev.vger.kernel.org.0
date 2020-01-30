Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF1914DCB9
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 15:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgA3OVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 09:21:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgA3OVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 09:21:37 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 241981489E0BE;
        Thu, 30 Jan 2020 06:21:35 -0800 (PST)
Date:   Thu, 30 Jan 2020 15:21:30 +0100 (CET)
Message-Id: <20200130.152130.1101636427406386761.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, adrianc@mellanox.com,
        danitg@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/core: Do not clear VF index for node/port
 GUIDs query
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200130125949.409354-1-leon@kernel.org>
References: <20200130125949.409354-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jan 2020 06:21:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 30 Jan 2020 14:59:49 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> VF numbers were assigned to node_guid and port_guid, but cleared
> right before such query calls were issued. It caused to return
> node/port GUIDs of VF index 0 for all VFs.
> 
> Fixes: 30aad41721e0 ("net/core: Add support for getting VF GUIDs")
> Reported-by: Adrian Chiris <adrianc@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Looks good, applied and queued up for -stable.
