Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977D187E63
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436789AbfHIPqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 11:46:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:57522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436647AbfHIPqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 11:46:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF353AD23;
        Fri,  9 Aug 2019 15:46:11 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 03EC8E0441; Fri,  9 Aug 2019 17:46:10 +0200 (CEST)
Date:   Fri, 9 Aug 2019 17:46:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190809154609.GG31971@unicorn.suse.cz>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 08:40:25AM -0700, Roopa Prabhu wrote:
> to that point, I am also not sure why we have a new API For multiple
> names. I mean why support more than two names  (existing old name and
> a new name to remove the length limitation) ?

One use case is to allow "predictable names" from udev/systemd to work
the way do for e.g. block devices, see

  http://lkml.kernel.org/r/20190628162716.GF29149@unicorn.suse.cz

Michal
