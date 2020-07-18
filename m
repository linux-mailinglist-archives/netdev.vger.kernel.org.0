Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB812247F5
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 04:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgGRCBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 22:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGRCBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 22:01:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDE0C0619D2;
        Fri, 17 Jul 2020 19:01:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A472311E45917;
        Fri, 17 Jul 2020 19:01:13 -0700 (PDT)
Date:   Fri, 17 Jul 2020 19:01:12 -0700 (PDT)
Message-Id: <20200717.190112.517267615402058796.davem@davemloft.net>
To:     mstarovoitov@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: atlantic: add support for FW 4.x
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717180147.8854-1-mstarovoitov@marvell.com>
References: <20200717180147.8854-1-mstarovoitov@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 19:01:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>
Date: Fri, 17 Jul 2020 21:01:45 +0300

> This patch set adds support for FW 4.x, which is about to get into the
> production for some products.
> 4.x is mostly compatible with 3.x, save for soft reset, which requires
> the acquisition of 2 additional semaphores.
> Other differences (e.g. absence of PTP support) are handled via
> capabilities.
> 
> Note: 4.x targets specific products only. 3.x is still the main firmware
> branch, which should be used by most users (at least for now).

Series applied, thanks.
