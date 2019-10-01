Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89BEC2B55
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 02:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbfJAAZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 20:25:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJAAZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 20:25:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB27F154F639B;
        Mon, 30 Sep 2019 17:25:51 -0700 (PDT)
Date:   Mon, 30 Sep 2019 17:25:51 -0700 (PDT)
Message-Id: <20190930.172551.1670850073296784762.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org, navid.emamdoost@gmail.com
Subject: Re: [PATCH net] net: dsa: sja1105: Prevent leaking memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190928224339.31784-1-olteanv@gmail.com>
References: <20190928224339.31784-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 17:25:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Sep 2019 01:43:39 +0300

> From: Navid Emamdoost <navid.emamdoost@gmail.com>
> 
> In sja1105_static_config_upload, in two cases memory is leaked: when
> static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
> fails. In both cases config_buf should be released.
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Fixes: 1a4c69406cc1 ("net: dsa: sja1105: Prevent PHY jabbering during switch reset")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable.
