Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3E202880
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 06:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgFUEa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 00:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFUEa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 00:30:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19336C061794;
        Sat, 20 Jun 2020 21:30:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC6B91274A806;
        Sat, 20 Jun 2020 21:30:58 -0700 (PDT)
Date:   Sat, 20 Jun 2020 21:30:58 -0700 (PDT)
Message-Id: <20200620.213058.331663043231093248.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2020-06-19
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619201459.894622-1-stefan@datenfreihafen.org>
References: <20200619201459.894622-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 21:30:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Fri, 19 Jun 2020 22:14:59 +0200

> An update from ieee802154 for your *net* tree.
> 
> Just two small maintenance fixes to update references to the new project
> homepage.

Applied, thanks.
