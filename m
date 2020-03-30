Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03143197378
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgC3Eeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:34:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32986 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3Eeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:34:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CA2115C50FD5;
        Sun, 29 Mar 2020 21:34:43 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:34:42 -0700 (PDT)
Message-Id: <20200329.213442.323423458733315119.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, mstarovoitov@marvell.com,
        sd@queasysnail.net, antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next] net: macsec: add support for specifying
 offload upon link creation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325130134.1129-1-irusskikh@marvell.com>
References: <20200325130134.1129-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:34:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Wed, 25 Mar 2020 16:01:34 +0300

> From: Mark Starovoytov <mstarovoitov@marvell.com>
> 
> This patch adds new netlink attribute to allow a user to (optionally)
> specify the desired offload mode immediately upon MACSec link creation.
> 
> Separate iproute patch will be required to support this from user space.
> 
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Applied to net-next, thank you.
