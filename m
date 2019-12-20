Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BB7128564
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfLTXL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:11:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLTXL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:11:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60E9C15162162;
        Fri, 20 Dec 2019 15:11:28 -0800 (PST)
Date:   Fri, 20 Dec 2019 15:11:27 -0800 (PST)
Message-Id: <20191220.151127.1948166805673220109.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, m-karicheri2@ti.com,
        robh+dt@kernel.org, willemb@google.com, w-kwok2@ti.com
Subject: Re: [PATCH V6 net-next 06/11] net: Introduce a new MII time
 stamping interface.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191220153359.GA11117@lunn.ch>
References: <20191217092155.GL6994@lunn.ch>
        <20191220145712.GA3846@localhost>
        <20191220153359.GA11117@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 15:11:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 20 Dec 2019 16:33:59 +0100

> On Fri, Dec 20, 2019 at 06:57:12AM -0800, Richard Cochran wrote:
>> On Tue, Dec 17, 2019 at 10:21:55AM +0100, Andrew Lunn wrote:
>> > Forward declarations are considered bad.
>> 
>> Not by me!
> 
> Lets see what David says.

I strongly dislike them too, it's indicative of poorly organized code.

It's pointless and avoidable clutter, and always when they exist people
never remember to remove them as code gets re-organized in the future.

Yeah, avoid forward declarations for sure.
