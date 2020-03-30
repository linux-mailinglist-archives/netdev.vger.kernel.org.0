Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19E41973DF
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgC3Fba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:31:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgC3Fb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:31:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A71F15C749DB;
        Sun, 29 Mar 2020 22:31:28 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:31:27 -0700 (PDT)
Message-Id: <20200329.223127.1598361580374806546.davem@davemloft.net>
To:     alex.aring@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
Subject: Re: [PATCHv3 net-next 0/5] net: ipv6: add rpl source routing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327220022.15220-1-alex.aring@gmail.com>
References: <20200327220022.15220-1-alex.aring@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:31:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>
Date: Fri, 27 Mar 2020 18:00:17 -0400

> This patch series will add handling for RPL source routing handling
> and insertion (implement as lwtunnel)! I did an example prototype
> implementation in rpld for using this implementation in non-storing mode:
> 
> https://github.com/linux-wpan/rpld/tree/nonstoring_mode
 ...

Series applied, thanks.
