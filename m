Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6413AA11E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhFPQWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:22:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPQWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vSj9Cw2sZFxnc9sBK2ngjmm4yp0EI6eDCnwHta6M3PY=; b=dN1d0OagilH+uvDgQKP38uz0wk
        /VkYnzhrn/4sLpCWNIK8qF53+lspPV0cME3/45rNmH1x0KuXITIvZ54jIbA3i0f4bC1miLaduZdCt
        1EgEJRewLEYuDcQC7/H7ZetOFAFmBgoZwPAk8myCPjb2ekJzMULjNyMDecLxhViupXRU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltYGt-009knE-3W; Wed, 16 Jun 2021 18:20:07 +0200
Date:   Wed, 16 Jun 2021 18:20:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH net-next 5/8] net: hdlc_ppp: fix the comments style issue
Message-ID: <YMoktwkvCP8yGyhk@lunn.ch>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
 <1623836037-26812-6-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623836037-26812-6-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int cp_table[EVENTS][STATES] = {
>  	/* CLOSED     STOPPED STOPPING REQ_SENT ACK_RECV ACK_SENT OPENED
> -	     0           1         2       3       4      5          6    */
> +	 *   0           1         2       3       4      5          6
> +	 */
>  	{IRC|SCR|3,     INV     , INV ,   INV   , INV ,  INV    ,   INV   }, /* START */
>  	{   INV   ,      0      ,  0  ,    0    ,  0  ,   0     ,    0    }, /* STOP */
>  	{   INV   ,     INV     ,STR|2,  SCR|3  ,SCR|3,  SCR|5  ,   INV   }, /* TO+ */

This probably reduces the readability of the code. So i would not make
this change.

Please remember these are only guidelines. Please don't blindly make
changes, or change it because some bot says so. Check that it actually
makes sense and the code is better afterwards.

      Andrew
