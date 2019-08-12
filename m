Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE888A8E1
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfHLVCv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Aug 2019 17:02:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfHLVCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:02:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69FCC154D32A7;
        Mon, 12 Aug 2019 14:02:50 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:02:44 -0700 (PDT)
Message-Id: <20190812.140244.1191094093267734606.davem@davemloft.net>
To:     git@andred.net
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: at803x: stop switching phy delay config
 needlessly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809112025.27482-1-git@andred.net>
References: <20190809005754.23009-1-git@andred.net>
        <20190809112025.27482-1-git@andred.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Aug 2019 14:02:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: André Draszik <git@andred.net>
Date: Fri,  9 Aug 2019 12:20:25 +0100

> This driver does a funny dance disabling and re-enabling
> RX and/or TX delays. In any of the RGMII-ID modes, it first
> disables the delays, just to re-enable them again right
> away. This looks like a needless exercise.
> 
> Just enable the respective delays when in any of the
> relevant 'id' modes, and disable them otherwise.
> 
> Also, remove comments which don't add anything that can't be
> seen by looking at the code.
> 
> Signed-off-by: André Draszik <git@andred.net>

Applied.
