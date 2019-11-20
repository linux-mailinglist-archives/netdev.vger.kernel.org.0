Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B500410354D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfKTHj6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Nov 2019 02:39:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:47148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfKTHj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 02:39:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 008F2B346;
        Wed, 20 Nov 2019 07:39:56 +0000 (UTC)
Date:   Wed, 20 Nov 2019 08:39:55 +0100
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     David Miller <davem@davemloft.net>
Cc:     corbet@lwn.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipconfig: Make device wait timeout
 configurable
Message-Id: <20191120083955.4c3dc7149a33518e9594293a@suse.de>
In-Reply-To: <20191119.184446.1007728375771623470.davem@davemloft.net>
References: <20191119120647.31547-1-tbogendoerfer@suse.de>
        <20191119.184446.1007728375771623470.davem@davemloft.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 18:44:46 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> Date: Tue, 19 Nov 2019 13:06:46 +0100
> 
> > If network device drivers are using deferred probing it's possible
> > that waiting for devices to show up in ipconfig is already over,
> > when the device eventually shows up. With the new netdev_max_wait
> > kernel cmdline pataremter it's now possible to extend this time.
> > 
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> 
> This is one of those "user's shouldn't have to figure this crap out"
> situations.
> 
> To me, a knob is always a step backwards, and makes Linux harder to
> use.
> 
> The irony in all of this, is that the kernel knows when this stuff is
> happening.  So the ipconfig code should be taught that drivers are
> still plugging themselves together and probing, instead of setting
> some arbitrary timeout to wait for these things to occur.

fine with, I'll have a look how to solve it taht way.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
