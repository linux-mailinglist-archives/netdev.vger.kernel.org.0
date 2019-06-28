Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2619B5A0C1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfF1Q1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:27:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:48912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726605AbfF1Q1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 12:27:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 664E2AB92;
        Fri, 28 Jun 2019 16:27:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 41D9CE00E0; Fri, 28 Jun 2019 18:27:16 +0200 (CEST)
Date:   Fri, 28 Jun 2019 18:27:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628162716.GF29149@unicorn.suse.cz>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <20190628111216.GA2568@nanopsycho>
 <20190628131401.GA27820@lunn.ch>
 <20190628135553.GA6640@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628135553.GA6640@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 03:55:53PM +0200, Jiri Pirko wrote:
> Fri, Jun 28, 2019 at 03:14:01PM CEST, andrew@lunn.ch wrote:
> >
> >What is your user case for having multiple IFLA_ALT_NAME for the same
> >IFLA_NAME?
> 
> I don't know about specific usecase for having more. Perhaps Michal
> does.

One use case that comes to my mind are the "predictable names"
implemented by udev/systemd which can be based on different naming
schemes (bus address, BIOS numbering, MAC address etc.) and it's not
always obvious which scheme is going to be used. I have even seen
multiple times that one schemed was used during system installation and
another in the installed system so that network configuration created by
installer did not work.

For block devices, current practice is not to rename the device and only
create multiple symlinks based on different naming schemes (by id, by
uuid, by label, etc.). With support for multiple altnames, we could also
identify the network device in different ways (all applicable ones).

Michal
