Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702C79D538
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733223AbfHZRwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:52:24 -0400
Received: from mail.nic.cz ([217.31.204.67]:33996 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbfHZRwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:52:24 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id D9654140940;
        Mon, 26 Aug 2019 19:52:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566841943; bh=WbPN4k+LUzFkFehLNi0Vcc9HPsyD3Kqbu09mmCynQOw=;
        h=Date:From:To;
        b=A+AYQkWZSMktUMoHFslxUqmeBKTpOAsOu4wbGePBCB7FN9Uz7bsydrO+GfTFYRu5H
         ORzt0iuajgJYgY3SeZyUKJx6j3GAjPLxQqtVeYewwRohcI6zEQY/hnhBE6DmmO4a1Z
         XeS4IjnHNuY15S+eH9zTSBS81dMWM3L9efrONqbM=
Date:   Mon, 26 Aug 2019 19:52:22 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 6/6] net: dsa: mv88e6xxx: fully support
 SERDES on Topaz family
Message-ID: <20190826195222.3f9e3f51@nic.cz>
In-Reply-To: <20190826134418.GB29480@t480s.localdomain>
References: <20190826122109.20660-1-marek.behun@nic.cz>
        <20190826122109.20660-7-marek.behun@nic.cz>
        <20190826153830.GE2168@lunn.ch>
        <20190826192717.50738e37@nic.cz>
        <20190826134418.GB29480@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 13:44:18 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> > It can be done once at probe. At first I thought about doing this in
> > setup_errata, but this is not an erratum. So shall I create a new
> > method for this in chip operations structure? Something like
> > port_additional_setup() ?  
> 
> No. Those "setup" or "config" functions are likely to do everything and
> become a mess, thus unmaintainable. Operations must be specific.

What about Andrew's complaint, then, abouth the two additional
parameters?
