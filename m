Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EAD45426
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfFNFoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:44:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfFNFoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:44:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9599F14DD925B;
        Thu, 13 Jun 2019 22:44:24 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:44:24 -0700 (PDT)
Message-Id: <20190613.224424.1142570129410696250.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve rtl_coalesce_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b3d61332-e45d-bc0c-db13-1017b92ef08a@gmail.com>
References: <b3d61332-e45d-bc0c-db13-1017b92ef08a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:44:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 11 Jun 2019 21:09:19 +0200

> tp->coalesce_info is used in rtl_coalesce_info() only, so we can
> remove this member. In addition replace phy_ethtool_get_link_ksettings
> with a direct access to tp->phydev->speed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
