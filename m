Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8F0A9FA9
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733220AbfIEK2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:28:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732324AbfIEK2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 06:28:40 -0400
Received: from localhost (unknown [89.248.140.11])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27C3215387C30;
        Thu,  5 Sep 2019 03:28:37 -0700 (PDT)
Date:   Thu, 05 Sep 2019 12:28:36 +0200 (CEST)
Message-Id: <20190905.122836.25502195044302631.davem@davemloft.net>
To:     asolokha@kb.kras.ru
Cc:     claudiu.manoil@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk, andrew@lunn.ch, olteanv@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] gianfar: some assorted cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190904135223.31754-1-asolokha@kb.kras.ru>
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
        <20190904135223.31754-1-asolokha@kb.kras.ru>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Sep 2019 03:28:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>
Date: Wed,  4 Sep 2019 20:52:18 +0700

> This is a cleanup series for the gianfar Ethernet driver, following up a
> discussion in [1]. It is intended to precede a conversion of gianfar from
> PHYLIB to PHYLINK API, which will be submitted later in its version 2.
> However, it won't make a conversion cleaner, except for the last patch in
> this series. Obviously this series is not intended for -stable.
> 
> The first patch looks super controversial to me, as it moves lots of code
> around for the sole purpose of getting rid of static forward declarations
> in two translation units. On the other hand, this change is purely
> mechanical and cannot do any harm other than cluttering git blame output.
> I can prepare an alternative patch for only swapping adjacent functions
> around, if necessary.
> 
> The second patch is a trivial follow-up to the first one, making functions
> that are only called from the same translation unit static.
> 
> The third patch removes some now unused macro and structure definitions
> from gianfar.h, slipped away from various cleanups in the past.
> 
> The fourth patch, also suggested in [1], makes the driver consistently use
> PHY connection type value obtained from a Device Tree node, instead of
> ignoring it and using the one auto-detected by MAC, when connecting to PHY.
> Obviously a value has to be specified correctly in DT source, or omitted
> altogether, in which case the driver will fall back to auto-detection. When
> querying a DT node, the driver will also take both applicable properties
> into account by making a proper API call instead of open-coding the lookup
> half-way correctly.
> 
> [1] https://lore.kernel.org/netdev/CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com/

Series applied, thanks.
