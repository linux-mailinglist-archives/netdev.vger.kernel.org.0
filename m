Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179BA27658E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIXBDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgIXBDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:03:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104EDC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 18:03:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EFA812638BAD;
        Wed, 23 Sep 2020 17:46:18 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:03:05 -0700 (PDT)
Message-Id: <20200923.180305.1319279123332013926.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 0/2] PHY subsystem kernel doc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922222903.3769629-1-andrew@lunn.ch>
References: <20200922222903.3769629-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:46:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 23 Sep 2020 00:29:01 +0200

> The first patches fix existing warnings in the kerneldoc for the PHY
> subsystem, and then the 2nd extend the kernel documentation for the
> major structures and functions in the PHY subsystem.
> 
> v2:
> Drop the other fixes which have already been merged.
> s/phy/PHY/g
> TBI
> TypOs

Series applied, thanks Andrew.
