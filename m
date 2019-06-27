Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD77B58970
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfF0SEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:04:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57614 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfF0SEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:04:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22D7B133E97CE;
        Thu, 27 Jun 2019 11:04:39 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:04:38 -0700 (PDT)
Message-Id: <20190627.110438.506551174335645620.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] FDB, VLAN and PTP fixes for SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:04:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 26 Jun 2019 02:39:32 +0300

> This patchset is an assortment of fixes for the net-next version of the
> sja1105 DSA driver:
> - Avoid a kernel panic when the driver fails to probe or unregisters
> - Finish Arnd Bermann's idea of compiling PTP support as part of the
>   main DSA driver and not separately
> - Better handling of initial port-based VLAN as well as VLANs for
>   dsa_8021q FDB entries
> - Fix address learning for the SJA1105 P/Q/R/S family
> - Make static FDB entries persistent across switch resets
> - Fix reporting of statically-added FDB entries in 'bridge fdb show'

Series applied, thanks.
