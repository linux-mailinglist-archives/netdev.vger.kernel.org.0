Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B66C4AFFE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 04:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbfFSC0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 22:26:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56692 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFSC0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 22:26:50 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69CB614DB02AD;
        Tue, 18 Jun 2019 19:26:33 -0700 (PDT)
Date:   Tue, 18 Jun 2019 22:26:24 -0400 (EDT)
Message-Id: <20190618.222624.192769316432594413.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 0/4] net: mvpp2: cls: Allow steering based on
 vlan tag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
References: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 19:26:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Tue, 18 Jun 2019 16:55:15 +0200

> The PPv2 classifier can perform flow steering based on keys extracted
> from the VLAN tag. This series adds support for using the vlan id and
> the vlan prio as keys, using the ethtool interface.
> 
> Patch 1 is a preparatory patch that prevent false-positive matches,
> using a dedicated lookup id for the RSS C2 lookup.
> 
> Patch 2 allows to separate the flows based on the header fields they
> contain. The main goal is to be able to separate tagged traffic from
> untagged traffic for flow steering, just as we already do for RSS.
> 
> Patch 3 solves an issue we have when extracting fields that aren't full
> bytes, such as the vlan tag which is 12 bits wide, or the priority which
> is 3 bits wide.
> 
> Finally, patch 4 adds support for steering based on both vlan id and
> priority, extracted from the outermost tag.

Series applied, thanks.
