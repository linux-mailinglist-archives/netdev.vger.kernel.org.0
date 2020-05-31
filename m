Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE321E94D6
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 03:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgEaBBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 21:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaBBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 21:01:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E94C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 18:01:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC3A2128DC136;
        Sat, 30 May 2020 18:01:03 -0700 (PDT)
Date:   Sat, 30 May 2020 18:01:02 -0700 (PDT)
Message-Id: <20200530.180102.1199744149558826705.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Fix 2 non-critical issues in SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530102953.692780-1-olteanv@gmail.com>
References: <20200530102953.692780-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 18:01:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 30 May 2020 13:29:51 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This small series suppresses the W=1 warnings in the sja1105 driver and
> it corrects some register offsets. I would like to target it against
> net-next since it would have non-trivial conflicts with net, and the
> problems it solves are not that big of a deal.

Series applied, thanks.
