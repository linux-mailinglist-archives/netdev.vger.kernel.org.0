Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD75EC757
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfKARPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:15:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKARPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:15:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C60EF15129611;
        Fri,  1 Nov 2019 10:15:18 -0700 (PDT)
Date:   Fri, 01 Nov 2019 10:15:18 -0700 (PDT)
Message-Id: <20191101.101518.2091216468172595538.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 07/12] net: atlantic: loopback tests via
 private flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <76690e382c4916800aa042b393721d263feb18fe.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
        <76690e382c4916800aa042b393721d263feb18fe.1572610156.git.irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 10:15:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Fri, 1 Nov 2019 12:17:21 +0000

> +int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
> +{
> +	struct aq_nic_s *aq_nic = netdev_priv(ndev);
> +	struct aq_nic_cfg_s *cfg = &aq_nic->aq_nic_cfg;
> +	u32 priv_flags = cfg->priv_flags;

Reverse christmas tree.

