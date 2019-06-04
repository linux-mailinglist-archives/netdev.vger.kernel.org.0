Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF8934FFE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFDSvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:51:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfFDSvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:51:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DFE3414FA95B2;
        Tue,  4 Jun 2019 11:51:16 -0700 (PDT)
Date:   Tue, 04 Jun 2019 11:51:16 -0700 (PDT)
Message-Id: <20190604.115116.1093876737939616742.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/11] FDB updates for SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 11:51:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  3 Jun 2019 00:11:52 +0300

> This patch series adds:
> 
> - FDB switchdev support for the second generation of switches (P/Q/R/S).
>   I could test/code these now that I got a board with a SJA1105Q.
> 
> - Management route support for SJA1105 P/Q/R/S. This is needed to send
>   PTP/STP/management frames over the CPU port.
> 
> - Logic to hide private DSA VLANs from the 'bridge fdb' commands.
> 
> The new FDB code was also tested and still works on SJA1105T.

Series applied, thanks.
