Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AF11815F
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 22:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfEHU6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 16:58:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52038 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfEHU6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 16:58:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D436913411E10;
        Wed,  8 May 2019 13:58:12 -0700 (PDT)
Date:   Wed, 08 May 2019 13:58:08 -0700 (PDT)
Message-Id: <20190508.135808.610382717397984273.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     dan.carpenter@oracle.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: Don't return a negative in u8
 sja1105_stp_state_get
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508203225.13275-1-olteanv@gmail.com>
References: <20190508203225.13275-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 13:58:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed,  8 May 2019 23:32:25 +0300

> Dan Carpenter says:
> 
> The patch 640f763f98c2: "net: dsa: sja1105: Add support for Spanning
> Tree Protocol" from May 5, 2019, leads to the following static
> checker warning:
> 
>         drivers/net/dsa/sja1105/sja1105_main.c:1073 sja1105_stp_state_get()
>         warn: signedness bug returning '(-22)'
> 
> The caller doesn't check for negative errors anyway.
> 
> Fixes: 640f763f98c2: ("net: dsa: sja1105: Add support for Spanning Tree Protocol")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.
