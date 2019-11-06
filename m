Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB1AF0BE8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfKFCKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:10:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFCKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:10:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4393D15103715;
        Tue,  5 Nov 2019 18:10:02 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:10:01 -0800 (PST)
Message-Id: <20191105.181001.647775687319656442.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH net-next 0/5] mv88e6xxx ATU occupancy as devlink
 resource
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105001301.27966-1-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:10:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue,  5 Nov 2019 01:12:56 +0100

> This patchset add generic support to DSA for devlink resources. The
> Marvell switch Address Translation Unit occupancy is then exported as
> a resource. In order to do this, the number of ATU entries is added to
> the per switch info structure. Helpers are added, and then the
> resource itself is then added.

Series applied, thanks Andrew.
