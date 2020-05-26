Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C6F1D6C56
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgEQTbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:31:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739D3C061A0C;
        Sun, 17 May 2020 12:31:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92386128A0772;
        Sun, 17 May 2020 12:31:24 -0700 (PDT)
Date:   Sun, 17 May 2020 12:31:24 -0700 (PDT)
Message-Id: <20200517.123124.1192834571134059077.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, eric.dumazet@gmail.com, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: disable rxvlan offload for
 the DSA master
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512234921.25460-1-olteanv@gmail.com>
References: <20200512234921.25460-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:31:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I've asked Eric to look at this twice and no response, so I'm marking this
deferred because I'm not applying this without someone knowledgable about
the quoted VLAN change can take a look at this.
