Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907ECA2F59
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfH3GCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:02:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbfH3GCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 02:02:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3B7E15447999;
        Thu, 29 Aug 2019 23:02:33 -0700 (PDT)
Date:   Thu, 29 Aug 2019 23:02:33 -0700 (PDT)
Message-Id: <20190829.230233.287975311556641534.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     idosch@idosch.org, andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to
 dev->promiscuity.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830053940.GL2312@nanopsycho>
References: <20190829193613.GA23259@splinter>
        <20190829.151201.940681219080864052.davem@davemloft.net>
        <20190830053940.GL2312@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 23:02:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 30 Aug 2019 07:39:40 +0200

> Because the "promisc mode" would gain another meaning. Now how the
> driver should guess which meaning the user ment when he setted it?
> filter or trap?
> 
> That is very confusing. If the flag is the way to do this, let's
> introduce another flag, like IFF_TRAPPING indicating that user wants
> exactly this.

I don't understand how the meaning of promiscuous mode for a
networking device has suddenly become ambiguous, when did this start
happening?
