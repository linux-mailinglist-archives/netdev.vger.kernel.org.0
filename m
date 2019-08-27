Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6179DD00
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfH0FJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:09:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:45326 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725795AbfH0FJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 01:09:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB8A7ABCB;
        Tue, 27 Aug 2019 05:09:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 53D79E0CFC; Tue, 27 Aug 2019 07:09:47 +0200 (CEST)
Date:   Tue, 27 Aug 2019 07:09:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        roopa@cumulusnetworks.com, sthemmin@microsoft.com, dcbw@redhat.com,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190827050947.GF29594@unicorn.suse.cz>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <ddd05712-e8c7-3c08-11c7-9840f5b64226@gmail.com>
 <20190826.152525.144590581669280532.davem@davemloft.net>
 <beb8ec07-f28e-4378-e8dd-fa6fe290377b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beb8ec07-f28e-4378-e8dd-fa6fe290377b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 06:17:08PM -0600, David Ahern wrote:
> 
> Something a bit stand alone would be a better choice - like all of the
> VF stuff, stats, per-device type configuration. Yes, that ship has
> sailed, but as I recall that is where the overhead is.

We are not so far from the point where IFLA_VFINFO_LIST grows over 64 KB
so that it does not fit into a netlink attribute. So we will probably
have to rethink that part anyway.

Michal
