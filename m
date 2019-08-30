Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C6A2FA2
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfH3GSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:18:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfH3GSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 02:18:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E27BA15448094;
        Thu, 29 Aug 2019 23:18:49 -0700 (PDT)
Date:   Thu, 29 Aug 2019 23:18:49 -0700 (PDT)
Message-Id: <20190829.231849.163267210593234149.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830061327.GM2312@nanopsycho>
References: <20190829134901.GJ2312@nanopsycho>
        <20190829143732.GB17864@lunn.ch>
        <20190830061327.GM2312@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 23:18:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 30 Aug 2019 08:13:27 +0200

> In fact, I have usecase where I need to see only slow-path traffic by
> wireshark, not all packets going through hw.

This could be an attribute in the descriptor entries for the packets
provided to userspace, and BPF filters could act on these as well.

Switch network devices aren't special, promiscuous mode means all
packets on the wire that you are attached.

This talk about special handling of "trapping" is a strawman.
