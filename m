Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516961FD816
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgFQWA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQWA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:00:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3212AC06174E;
        Wed, 17 Jun 2020 15:00:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0C2E1296740B;
        Wed, 17 Jun 2020 15:00:56 -0700 (PDT)
Date:   Wed, 17 Jun 2020 15:00:56 -0700 (PDT)
Message-Id: <20200617.150056.2181232797358383111.davem@davemloft.net>
To:     jk@ozlabs.org
Cc:     netdev@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw,
        pfink@christ-es.de, linux-usb@vger.kernel.org, louis@asix.com.tw
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ac9ac673933f0e8383c6ab538302058ba2469192.camel@ozlabs.org>
References: <e780f13fdde89d03ef863618d8de3dd67ba53c72.camel@ozlabs.org>
        <20200616.135535.379478681934951754.davem@davemloft.net>
        <ac9ac673933f0e8383c6ab538302058ba2469192.camel@ozlabs.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 15:00:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Wed, 17 Jun 2020 08:56:39 +0800

> [If you have any hints for forcing clustered packets, I'll see if I can
> probe the behaviour a little better to confirm]

Probably it would involve having packets arrive back to back faster
than some interval that either depends upon real time or some multiple
of a USB bus cycle.
