Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA6B9F981
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfH1Emg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Aug 2019 00:42:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfH1Emg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:42:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44C98153C23DD;
        Tue, 27 Aug 2019 21:42:35 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:42:34 -0700 (PDT)
Message-Id: <20190827.214234.1744683677161165998.davem@davemloft.net>
To:     marek.behun@nic.cz
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v5 0/6] net: dsa: mv88e6xxx: Peridot/Topaz
 SERDES changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826213155.14685-1-marek.behun@nic.cz>
References: <20190826213155.14685-1-marek.behun@nic.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 21:42:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>
Date: Mon, 26 Aug 2019 23:31:49 +0200

> this is the fifth version of changes for the Topaz/Peridot family of
> switches. The patches apply on net-next.
> Changes since v4:
>  - added Reviewed-by and Tested-by tags on first 2 patches, the others
>    are changed are affected by changes in patch 3/6, so I did not add
>    the tags, except for 5/6, which is just macro renaming
>  - patch 3 was changed: the serdes_get_lane returns 0 on success (lane
>    was discovered), -ENODEV if not lane is present on the port, and
>    other error if other error occured. Lane is put into a pointer of
>    type u8
>  - patches 4 and 6 were affected by this (error detecting from
>    serdes_get_lane)
>  - Andrew's complaint about the two additional parameters
>    (allow_over_2500 and make_cmode_writable) was addressed, by Vivien's
>    advice: I put a new method into chip operations structure, named
>    port_set_cmode_writable. This is called from mv88e6xxx_port_setup_mac
>    just before port_set_cmode. The method is implemented for Topaz.
>    The check if cmodes over 2500 should be allowed on given port is now
>    done in the specific port_set_cmode() that requires it, thus the
>    allow_over_2500 argument is not needed
> 
> Again, tested on Turris Mox with Peridot, Topaz, and Peridot + Topaz.

Series applied, thank you.
