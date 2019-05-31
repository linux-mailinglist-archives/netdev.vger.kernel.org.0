Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F2531558
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfEaT3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:29:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49188 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfEaT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:29:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A76B150047CA;
        Fri, 31 May 2019 12:29:21 -0700 (PDT)
Date:   Fri, 31 May 2019 12:29:18 -0700 (PDT)
Message-Id: <20190531.122918.1149944019162498846.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next] net: phy: phylink: support using device PHY
 in fixed or 802.3z mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
        <1559330285-30246-5-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 12:29:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


So many changes to the same file that seem somehow related.

Therefore, why didn't you put this stuff into a formal patch series?
