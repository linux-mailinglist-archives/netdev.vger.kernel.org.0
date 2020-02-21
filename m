Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B112216831F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgBUQSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:18:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgBUQSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 11:18:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DCAA4121103EB;
        Fri, 21 Feb 2020 08:18:54 -0800 (PST)
Date:   Fri, 21 Feb 2020 08:18:54 -0800 (PST)
Message-Id: <20200221.081854.677544975097982654.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] enetc: remove "depends on (ARCH_LAYERSCAPE ||
 COMPILE_TEST)"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221144624.20289-1-olteanv@gmail.com>
References: <20200221144624.20289-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 08:18:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 21 Feb 2020 16:46:24 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ARCH_LAYERSCAPE isn't needed for this driver, it builds and
> sends/receives traffic without this config option just fine.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
