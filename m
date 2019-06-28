Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3135A5ED
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfF1Ueo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:34:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51398 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfF1Ueo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:34:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 602E1133FC82A;
        Fri, 28 Jun 2019 13:34:43 -0700 (PDT)
Date:   Fri, 28 Jun 2019 13:34:33 -0700 (PDT)
Message-Id: <20190628.133433.967419425312431632.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     b.spranger@linutronix.de, netdev@vger.kernel.org,
        bigeasy@linutronix.de, kurt@linutronix.de, andrew@lunn.ch,
        vivien.didelot@gmail.com
Subject: Re: [PATCH 1/1] net: dsa: b53: Disable all ports on setup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d5df00f5-599c-56ce-f93e-31587d16145a@gmail.com>
References: <20190628165811.30964-1-b.spranger@linutronix.de>
        <20190628165811.30964-2-b.spranger@linutronix.de>
        <d5df00f5-599c-56ce-f93e-31587d16145a@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 13:34:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 28 Jun 2019 10:23:06 -0700

> On 6/28/19 9:58 AM, Benedikt Spranger wrote:
>> A b53 device may configured through an external EEPROM like the switch
>> device on the Lamobo R1 router board. The configuration of a port may
>> therefore differ from the reset configuration of the switch.
>> 
>> The switch configuration reported by the DSA subsystem is different until
>> the port is configured by DSA i.e. a port can be active, while the DSA
>> subsystem reports the port is inactive. Disable all ports and not only
>> the unused ones to put all ports into a well defined state.
>> 
>> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
