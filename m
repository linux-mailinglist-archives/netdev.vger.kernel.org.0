Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E395ECAD7
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKAWJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:09:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAWJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:09:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAB3D151B09AA;
        Fri,  1 Nov 2019 15:09:11 -0700 (PDT)
Date:   Fri, 01 Nov 2019 15:09:11 -0700 (PDT)
Message-Id: <20191101.150911.1113887725413553825.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix IMP setup for port
 different than 8
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031225406.10576-1-f.fainelli@gmail.com>
References: <20191031225406.10576-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 15:09:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 31 Oct 2019 15:54:05 -0700

> Since it became possible for the DSA core to use a CPU port different
> than 8, our bcm_sf2_imp_setup() function was broken because it assumes
> that registers are applicable to port 8. In particular, the port's MAC
> is going to stay disabled, so make sure we clear the RX_DIS and TX_DIS
> bits if we are not configured for port 8.
> 
> Fixes: 9f91484f6fcc ("net: dsa: make "label" property optional for dsa2")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable.
