Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEB945EB75
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377279AbhKZK33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:29:29 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54961 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376707AbhKZK12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 05:27:28 -0500
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 5F7334000D;
        Fri, 26 Nov 2021 10:24:11 +0000 (UTC)
Date:   Fri, 26 Nov 2021 11:24:10 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Subject: Re: [PATCH net-next 4/4] net: mvneta: Add TC traffic shaping
 offload
Message-ID: <20211126112410.549a108d@bootlin.com>
In-Reply-To: <20211125095029.342b3594@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
        <20211125154813.579169-5-maxime.chevallier@bootlin.com>
        <20211125095029.342b3594@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Thu, 25 Nov 2021 09:50:29 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

>On Thu, 25 Nov 2021 16:48:13 +0100 Maxime Chevallier wrote:
>> The mvneta controller is able to do some tocken-bucket per-queue traffic
>> shaping. This commit adds support for setting these using the TC mqprio
>> interface.
>> 
>> The token-bucket parameters are customisable, but the current
>> implementation configures them to have a 10kbps resolution for the
>> rate limitation, since it allows to cover the whole range of max_rate
>> values from 10kbps to 5Gbps with 10kbps increments.
>> 
>> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
>
>Breaks 32bit build, please make sure you use division helpers for 64b.

My bad, I'll update to use the proper helpers then (and compile-test
for 32bits this time too, sorry about that)

Thanks,

Maxime

-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
