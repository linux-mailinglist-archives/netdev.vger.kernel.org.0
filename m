Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848619F8C7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfH1DcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:32:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfH1DcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:32:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60D6F153B9190;
        Tue, 27 Aug 2019 20:32:13 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:32:12 -0700 (PDT)
Message-Id: <20190827.203212.515116185322653581.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: tag_8021q: Future-proof the reserved
 fields in the custom VID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190825183212.11426-1-olteanv@gmail.com>
References: <20190825183212.11426-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:32:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 25 Aug 2019 21:32:12 +0300

> After witnessing the discussion in https://lkml.org/lkml/2019/8/14/151
> w.r.t. ioctl extensibility, it became clear that such an issue might
> prevent that the 3 RSV bits inside the DSA 802.1Q tag might also suffer
> the same fate and be useless for further extension.
> 
> So clearly specify that the reserved bits should currently be
> transmitted as zero and ignored on receive. The DSA tagger already does
> this (and has always did), and is the only known user so far (no
> Wireshark dissection plugin, etc). So there should be no incompatibility
> to speak of.
> 
> Fixes: 0471dd429cea ("net: dsa: tag_8021q: Create a stable binary format")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for v5.2 -stable.
