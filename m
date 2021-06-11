Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078A83A4800
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFKRkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:40:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46248 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhFKRkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 13:40:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 0E47C429B7911;
        Fri, 11 Jun 2021 10:38:01 -0700 (PDT)
Date:   Fri, 11 Jun 2021 10:37:57 -0700 (PDT)
Message-Id: <20210611.103757.1539292762797979537.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     olteanv@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        richardcochran@gmail.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH v2 net-next 00/10] DSA tagging driver for NXP SJA1110
From:   David Miller <davem@davemloft.net>
In-Reply-To: <YMLXyf5g/PLSYpj7@lunn.ch>
References: <20210610.165050.1024675046668459735.davem@davemloft.net>
        <20210611000915.ufp2db4qtv2vsjqb@skbuf>
        <YMLXyf5g/PLSYpj7@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 11 Jun 2021 10:38:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 11 Jun 2021 05:26:01 +0200

> git am is very pedantic. It does not use fuzz. So just moving lines
> within the same line is unlikely to work, you need to make the changes
> in non intersecting sets of files.
> 
> Your best bet is to be patient and wait for one patchset to get
> merged, and then submit the second patchset.

Indeed.
