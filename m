Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4475C27099D
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 03:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgISBUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 21:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISBUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 21:20:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7A6C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 18:20:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB86315B52EA2;
        Fri, 18 Sep 2020 18:03:18 -0700 (PDT)
Date:   Fri, 18 Sep 2020 18:20:05 -0700 (PDT)
Message-Id: <20200918.182005.1313348363341066856.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, cphealy@gmail.com, f.fainelli@gmail.com,
        jiri@nvidia.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v4 0/9] mv88e6xxx: Add devlink regions support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918191109.3640779-1-andrew@lunn.ch>
References: <20200918191109.3640779-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 18:03:19 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 18 Sep 2020 21:11:00 +0200

> Make use of devlink regions to allow read access to some of the
> internal of the switches. Currently access to global1, global2 and the
> ATU is provided.
> 
> The switch itself will never trigger a region snapshot, it is assumed
> it is performed from user space as needed.
 ...

Series applied, thanks Andrew.
