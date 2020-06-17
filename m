Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EEC1FD873
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgFQWMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbgFQWMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:12:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07489C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 15:12:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B66CD1297DACB;
        Wed, 17 Jun 2020 15:12:05 -0700 (PDT)
Date:   Wed, 17 Jun 2020 15:12:04 -0700 (PDT)
Message-Id: <20200617.151204.1301385170348815787.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: export features for vlans to use
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616150626.42738-1-snelson@pensando.io>
References: <20200616150626.42738-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 15:12:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue, 16 Jun 2020 08:06:26 -0700

> Set up vlan_features for use by any vlans above us.
> 
> Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thanks.
