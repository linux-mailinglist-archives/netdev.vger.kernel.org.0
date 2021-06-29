Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34C13B7A4C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 00:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbhF2WLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 18:11:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38660 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhF2WLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 18:11:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4282A4F7E3849;
        Tue, 29 Jun 2021 15:08:46 -0700 (PDT)
Date:   Tue, 29 Jun 2021 15:08:42 -0700 (PDT)
Message-Id: <20210629.150842.66124616027054264.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, tobias@waldekranz.com, roopa@nvidia.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v5 net-next 00/15] RX filtering in DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210629190923.kf5utzbhmmgszwwc@skbuf>
References: <20210629.115213.547056454675149348.davem@davemloft.net>
        <20210629185822.ir3vp52xkyddm3j3@skbuf>
        <20210629190923.kf5utzbhmmgszwwc@skbuf>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 29 Jun 2021 15:08:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 29 Jun 2021 22:09:23 +0300

> On Tue, Jun 29, 2021 at 09:58:22PM +0300, Vladimir Oltean wrote:
>> On Tue, Jun 29, 2021 at 11:52:13AM -0700, David Miller wrote:
>> > From: Vladimir Oltean <olteanv@gmail.com>
>> > Date: Tue, 29 Jun 2021 17:06:43 +0300
>> > 
>> > > Changes in v5:
>> > > - added READ_ONCE and WRITE_ONCE for fdb->dst
>> > > - removed a paranoid WARN_ON in DSA
>> > > - added some documentation regarding how 'bridge fdb' is supposed to be
>> > >   used with DSA
>> > 
>> > Vlad, I applied v4, could you please send me relative fixups to v5?
>> > 
>> > Thank you.
>> 
>> Thanks for applying. I'm going to prepare the delta patches right now.
> 
> Dave, is it possible that you may have applied v5 with the cover letter
> from v4? I checked and everything is in its right place:

Yes I believe that is what happened.

Thanks for checking...
