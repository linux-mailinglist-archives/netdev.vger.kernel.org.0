Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909EF24E63
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfEULzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:55:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:41288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbfEULzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 07:55:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 216A5ABE7;
        Tue, 21 May 2019 11:55:23 +0000 (UTC)
Message-ID: <1558438944.12672.13.camel@suse.com>
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
From:   Oliver Neukum <oneukum@suse.com>
To:     Kloetzke Jan <Jan.Kloetzke@preh.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "jan@kloetzke.net" <jan@kloetzke.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 21 May 2019 13:42:24 +0200
In-Reply-To: <1558433542.19453.33.camel@preh.de>
References: <1556563688.20085.31.camel@suse.com>
         <20190430141440.9469-1-Jan.Kloetzke@preh.de>
         <20190505.004556.492323065607253635.davem@davemloft.net>
         <1557130666.12778.3.camel@suse.com> <1557990629.19453.7.camel@preh.de>
         <1558432122.12672.12.camel@suse.com> <1558433542.19453.33.camel@preh.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Di, 2019-05-21 at 10:12 +0000, Kloetzke Jan wrote:
> 
> Why not just take v1 of the patch?
> 
>   https://lore.kernel.org/netdev/20190417091849.7475-1-Jan.Kloetzke@preh.de/
> 
> The original version was exactly the same, just without the WARN_ON().
> Or is it required to send a v3 in this case?

It will make things easier for Dave to pick up.

	Regards
		Oliver

