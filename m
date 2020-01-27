Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77AA14A17D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgA0KJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:09:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgA0KJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:09:47 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 883BE151283E3;
        Mon, 27 Jan 2020 02:09:46 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:09:44 +0100 (CET)
Message-Id: <20200127.110944.1937642848582237999.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove eth_change_mtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f6c76898-a0ce-b2ce-3f51-bb12d0010c05@gmail.com>
References: <f6c76898-a0ce-b2ce-3f51-bb12d0010c05@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:09:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 25 Jan 2020 13:42:14 +0100

> All usage of this function was removed three years ago, and the
> function was marked as deprecated:
> a52ad514fdf3 ("net: deprecate eth_change_mtu, remove usage")
> So I think we can remove it now.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
