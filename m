Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7139A39C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405459AbfHVXQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:16:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394284AbfHVXQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:16:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F2891539AF1E;
        Thu, 22 Aug 2019 16:16:23 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:16:22 -0700 (PDT)
Message-Id: <20190822.161622.97568202266351755.davem@davemloft.net>
To:     marco.hartmann@nxp.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, christian.herber@nxp.com
Subject: Re: [PATCH v2 net-next] net: fec: add C45 MDIO read/write support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566387814-7034-1-git-send-email-marco.hartmann@nxp.com>
References: <1566387814-7034-1-git-send-email-marco.hartmann@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 16:16:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Hartmann <marco.hartmann@nxp.com>
Date: Wed, 21 Aug 2019 11:43:49 +0000

> IEEE 802.3ae clause 45 defines a modified MDIO protocol that uses a two
> staged access model in order to increase the address space.
> 
> This patch adds support for C45 MDIO read and write accesses, which are
> used whenever the MII_ADDR_C45 flag in the regnum argument is set.
> In case it is not set, C22 accesses are used as before.
> 
> Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
> ---
> Changes in v2:
> - use bool variable is_c45
> - add missing goto statements

Applied, thank you.
