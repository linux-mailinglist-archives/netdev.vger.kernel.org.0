Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47973ABCD
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfFIUhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:37:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIUhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:37:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B5B914DF427B;
        Sun,  9 Jun 2019 13:37:11 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:37:10 -0700 (PDT)
Message-Id: <20190609.133710.1505816962132753152.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: make debugging output more succinct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0e12b390-9b47-ae24-3a1b-4f602c57a779@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
        <20190607145933.37058-9-jarod@redhat.com>
        <0e12b390-9b47-ae24-3a1b-4f602c57a779@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:37:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 7 Jun 2019 11:02:34 -0400

> On 6/7/19 10:59 AM, Jarod Wilson wrote:
>> Seeing bonding debug log data along the lines of "event: 5" is a bit
>> spartan,
>> and often requires a lookup table if you don't remember what every
>> event is.
>> Make use of netdev_cmd_to_name for an improved debugging experience,
>> so for
>> the prior example, you'll see: "bond_netdev_event received
>> NETDEV_REGISTER"
>> instead (both are prefixed with the device for which the event
>> pertains).
>> There are also quite a few places that the netdev_dbg output could
>> stand to
>> mention exactly which slave the message pertains to (gets messy if you
>> have
>> multiple slaves all spewing at once to know which one they pertain
>> to).
> 
> Argh. Please drop this one, detritus in my git tree when I hit git
> send-email caused this earlier iteration of patch 1 of the set this is
> threaded with to go out.

Ok.
