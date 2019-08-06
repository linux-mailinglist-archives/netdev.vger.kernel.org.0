Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDEE83ACC
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfHFVI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:08:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfHFVI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:08:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25B9C1265AE29;
        Tue,  6 Aug 2019 14:08:56 -0700 (PDT)
Date:   Tue, 06 Aug 2019 14:08:55 -0700 (PDT)
Message-Id: <20190806.140855.590146630325178732.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        linville@redhat.com, cphealy@gmail.com
Subject: Re: [PATCH net-next] net: dsa: dump CPU port regs through master
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190802193455.17126-2-vivien.didelot@gmail.com>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
        <20190802193455.17126-2-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 14:08:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Fri,  2 Aug 2019 15:34:55 -0400

> Merge the CPU port registers dump into the master interface registers
> dump through ethtool, by nesting the ethtool_drvinfo and ethtool_regs
> structures of the CPU port into the dump.
> 
> drvinfo->regdump_len will contain the full data length, while regs->len
> will contain only the master interface registers dump length.
> 
> This allows for example to dump the CPU port registers on a ZII Dev
> C board like this:
 ...
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied, thanks Vivien.
