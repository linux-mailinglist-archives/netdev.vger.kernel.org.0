Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953CF1C0B53
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 02:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgEAAns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 20:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEAAns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 20:43:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E2EC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 17:43:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8942127404DA;
        Thu, 30 Apr 2020 17:43:47 -0700 (PDT)
Date:   Thu, 30 Apr 2020 17:43:46 -0700 (PDT)
Message-Id: <20200430.174346.907323978745001891.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: ARL improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430184911.29660-1-f.fainelli@gmail.com>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 17:43:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 30 Apr 2020 11:49:07 -0700

> This patch series improves the b53 driver ARL search code by
> renaming the ARL entries to be reflective of what they are: bins, and
> then introduce the number of buckets so we can properly bound check ARL
> searches.
> 
> The final patch removes an unused argument.

Series applied, thanks.
