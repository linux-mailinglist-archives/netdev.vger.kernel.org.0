Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA41A3071
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfH3HM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:12:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfH3HM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:12:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::642])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D60F01544E2D5;
        Fri, 30 Aug 2019 00:12:25 -0700 (PDT)
Date:   Fri, 30 Aug 2019 00:12:23 -0700 (PDT)
Message-Id: <20190830.001223.669650763835949848.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     idosch@idosch.org, andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830063624.GN2312@nanopsycho>
References: <20190830053940.GL2312@nanopsycho>
        <20190829.230233.287975311556641534.davem@davemloft.net>
        <20190830063624.GN2312@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 00:12:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 30 Aug 2019 08:36:24 +0200

> The promiscuity is a way to setup the rx filter. So promics == rx filter
> off. For normal nics, where there is no hw fwd datapath,
> this coincidentally means all received packets go to cpu.

You cannot convince me that the HW datapath isn't a "rx filter" too, sorry.
