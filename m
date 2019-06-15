Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F266946E00
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfFODUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:20:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfFODUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 23:20:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 999D7140518E3;
        Fri, 14 Jun 2019 20:20:20 -0700 (PDT)
Date:   Fri, 14 Jun 2019 20:20:20 -0700 (PDT)
Message-Id: <20190614.202020.2299196626940226476.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/4] net: dsa: use switchdev attr and obj
 handlers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614174922.2590-1-vivien.didelot@gmail.com>
References: <20190614174922.2590-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 20:20:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Fri, 14 Jun 2019 13:49:18 -0400

> This series reduces boilerplate in the handling of switchdev attribute and
> object operations by using the switchdev_handle_* helpers, which check the
> targeted devices and recurse into their lower devices.
> 
> This also brings back the ability to inspect operations targeting the bridge
> device itself (where .orig_dev and .dev were originally the bridge device),
> even though that is of no use yet and skipped by this series.
> 
> Changes in v2: Only VLAN and (non-host) MDB objects not directly targeting
> the slave device are unsupported at the moment, so only skip these cases.

Series applied.
