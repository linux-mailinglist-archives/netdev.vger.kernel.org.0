Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD35B30446
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfE3Vxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:53:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfE3Vxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:53:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9743514DB3D1D;
        Thu, 30 May 2019 14:47:28 -0700 (PDT)
Date:   Thu, 30 May 2019 14:47:28 -0700 (PDT)
Message-Id: <20190530.144728.2263518019034067506.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 0/2] Fixes for DSA tagging using 802.1Q
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529214231.10485-1-olteanv@gmail.com>
References: <20190529214231.10485-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:47:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 30 May 2019 00:42:29 +0300

> During the prototyping for the "Decoupling PHYLINK from struct
> net_device" patchset, the CPU port of the sja1105 driver was moved to a
> different spot.  This uncovered an issue in the tag_8021q DSA code,
> which used to work by mistake - the CPU port was the last hardware port
> numerically, and this was masking an ordering issue which is very likely
> to be seen in other drivers that make use of 802.1Q tags.
> 
> A question was also raised whether the VID numbers bear any meaning, and
> the conclusion was that they don't, at least not in an absolute sense.
> The second patch defines bit fields inside the DSA 802.1Q VID so that
> tcpdump can decode it unambiguously (although the meaning is now clear
> even by visual inspection).

Series applied.
