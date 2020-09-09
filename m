Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38B6263832
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgIIVHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIIVHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:07:36 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04345C061573;
        Wed,  9 Sep 2020 14:07:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 4BAF1140A64;
        Wed,  9 Sep 2020 23:07:27 +0200 (CEST)
Date:   Wed, 9 Sep 2020 23:07:26 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909230726.233b4081@nic.cz>
In-Reply-To: <20200909205923.GB3056507@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-2-marek.behun@nic.cz>
        <20200909182730.GK3290129@lunn.ch>
        <20200909203310.15ca4e42@dellmb.labs.office.nic.cz>
        <20200909205923.GB3056507@bogus>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 14:59:23 -0600
Rob Herring <robh@kernel.org> wrote:

> > 
> > I don't know :) I copied this from other drivers, I once tried setting
> > up environment for doing checking of device trees with YAML schemas,
> > and it was a little painful :)  
> 
> pip3 install dtschema ?
> 
> Can you elaborate on the issue.
> 
> Rob
> 

I am using Gentoo and didn't want to bloat system with non-portage
packages, nor try to start a virtual environment. In the end I did it
in a chroot Ubuntu :)

The other thing is that the make dt_binding_check executed for
quite a long time, and I didn't find a way to just do the binding check
some of the schemas.

But I am not criticizing anything, I think that it is a good thing to
have this system.

Marek
