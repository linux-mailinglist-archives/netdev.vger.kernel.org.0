Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251B8A2B5D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfH3AUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:20:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55750 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfH3AUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:20:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9698153CBC3A;
        Thu, 29 Aug 2019 17:20:43 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:20:43 -0700 (PDT)
Message-Id: <20190829.172043.156380676005553937.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: keep CMODE writable code
 private
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828162659.10306-1-vivien.didelot@gmail.com>
References: <20190828162659.10306-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:20:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 28 Aug 2019 12:26:59 -0400

> This is a follow-up patch for commit 7a3007d22e8d ("net: dsa:
> mv88e6xxx: fully support SERDES on Topaz family").
> 
> Since .port_set_cmode is only called from mv88e6xxx_port_setup_mac and
> mv88e6xxx_phylink_mac_config, it is fine to keep this "make writable"
> code private to the mv88e6341_port_set_cmode implementation, instead
> of adding yet another operation to the switch info structure.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied.
