Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459FB280C34
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgJBCFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733275AbgJBCFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:05:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C69C0613D0;
        Thu,  1 Oct 2020 19:05:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DA7B128747C4;
        Thu,  1 Oct 2020 18:48:52 -0700 (PDT)
Date:   Thu, 01 Oct 2020 19:05:39 -0700 (PDT)
Message-Id: <20201001.190539.943246074133907153.davem@davemloft.net>
To:     l.stelmach@samsung.com
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        b.zolnierkie@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH] net/smscx5xx: change to of_get_mac_address()
 eth_platform_get_mac_address()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930142525.23261-1-l.stelmach@samsung.com>
References: <CGME20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e@eucas1p1.samsung.com>
        <20200930142525.23261-1-l.stelmach@samsung.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:48:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ¨©ukasz Stelmach <l.stelmach@samsung.com>
Date: Wed, 30 Sep 2020 16:25:25 +0200

> Use more generic eth_platform_get_mac_address() which can get a MAC
> address from other than DT platform specific sources too. Check if the
> obtained address is valid.
> 
> Signed-off-by: ¨©ukasz Stelmach <l.stelmach@samsung.com>

Failure to probe a MAC address should result in the selection of a
random one.  This way, the interface still comes up and is usable
even when the MAC address fails to be probed.
