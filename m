Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C4723B036
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgHCWcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgHCWcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:32:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE736C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:32:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15B131277496A;
        Mon,  3 Aug 2020 15:15:34 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:32:18 -0700 (PDT)
Message-Id: <20200803.153218.52382861323010638.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 0/3] ionic txrx updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731201536.18246-1-snelson@pensando.io>
References: <20200731201536.18246-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:15:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Fri, 31 Jul 2020 13:15:33 -0700

> These are a few patches to do some cleanup in the packet
> handling and give us more flexibility in tuning performance
> by allowing us to put Tx handling on separate interrupts
> when it makes sense for particular traffic loads.
> 
> v3: simplified queue count change logging, removed unnecessary
>     check for no count change
> v2: dropped the original patch 2 for ringsize change
>     changed the separated tx/rx interrupts to use ethtool -L

Series applied, thanks.
