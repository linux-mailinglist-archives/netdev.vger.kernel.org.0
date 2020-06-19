Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEF8200059
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 04:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgFSCly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 22:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgFSCly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 22:41:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B52C06174E;
        Thu, 18 Jun 2020 19:41:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4EFB120ED499;
        Thu, 18 Jun 2020 19:41:50 -0700 (PDT)
Date:   Thu, 18 Jun 2020 19:41:48 -0700 (PDT)
Message-Id: <20200618.194148.1820981430913267555.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix node reference count
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618125640.GL249144@lunn.ch>
References: <20200618034245.29928-1-f.fainelli@gmail.com>
        <20200618125640.GL249144@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 19:41:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 18 Jun 2020 14:56:40 +0200

> That if_find_node_by_name() does a put is not very intuitive.
> Maybe document that as well in the kerneldocs?
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I've been complaining about the non-intuitiveness of the various
OF interfaces for a long time.  They transfer reference counts
across objects, and that makes the logic hard to audit.

The iterators are the worst.
