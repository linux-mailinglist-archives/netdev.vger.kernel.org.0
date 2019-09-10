Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB20CAEF06
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394021AbfIJPxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:53:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfIJPxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:53:50 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7889154F7873;
        Tue, 10 Sep 2019 08:53:48 -0700 (PDT)
Date:   Tue, 10 Sep 2019 17:53:46 +0200 (CEST)
Message-Id: <20190910.175346.22497410519110377.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 0/3] net: dsa: mv88e6xxx: add PCL support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190907200049.25273-1-vivien.didelot@gmail.com>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 08:53:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Sat,  7 Sep 2019 16:00:46 -0400

> This small series implements the ethtool RXNFC operations in the
> mv88e6xxx DSA driver to configure a port's Layer 2 Policy Control List
> (PCL) supported by models such as 88E6352 and 88E6390 and equivalent.
> 
> This allows to configure a port to discard frames based on a configured
> destination or source MAC address and an optional VLAN, with e.g.:
> 
>     # ethtool --config-nfc lan1 flow-type ether src 00:11:22:33:44:55 action -1

Series applied, thanks.
