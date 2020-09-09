Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4907A2625B8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIIDNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIIDNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:13:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295C3C061573;
        Tue,  8 Sep 2020 20:13:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EFA511E3E4C3;
        Tue,  8 Sep 2020 19:56:45 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:13:31 -0700 (PDT)
Message-Id: <20200908.201331.1892611505040051123.davem@davemloft.net>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: Re: pull-request: ieee802154 for net 2020-09-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908174216.461554-1-stefan@datenfreihafen.org>
References: <20200908174216.461554-1-stefan@datenfreihafen.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:56:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Schmidt <stefan@datenfreihafen.org>
Date: Tue,  8 Sep 2020 19:42:16 +0200

> An update from ieee802154 for your *net* tree.
> 
> A potential memory leak fix for ca8210 from Liu Jian,
> a check on the return for a register read in adf7242
> and finally a user after free fix in the softmac tx
> function from Eric found by syzkaller.

Pulled, thanks Stefan.
