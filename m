Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA651859EE
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgCOD5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:57:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgCOD5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:57:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A8DC15B75288;
        Sat, 14 Mar 2020 20:57:48 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:57:47 -0700 (PDT)
Message-Id: <20200314.205747.932715256447256917.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: support configuring vf spoofchk on EF10
 VFs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f4055a13-c3bd-ebf1-86fb-6fc64da4d363@solarflare.com>
References: <f4055a13-c3bd-ebf1-86fb-6fc64da4d363@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:57:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Thu, 12 Mar 2020 19:21:39 +0000

> Corresponds to the MAC_SPOOFING_TX privilege in the hardware.
> Some firmware versions on some cards don't support the feature, so check
>  the TX_MAC_SECURITY capability and fail EOPNOTSUPP if trying to enable
>  spoofchk on a NIC that doesn't support it.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thank you.
