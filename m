Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D581CE8DB
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEKXLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbgEKXLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:11:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103B7C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:11:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 870761210BB6C;
        Mon, 11 May 2020 16:11:06 -0700 (PDT)
Date:   Mon, 11 May 2020 16:11:05 -0700 (PDT)
Message-Id: <20200511.161105.2010361750917771255.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: tag_ocelot: use a short prefix
 on both ingress and egress
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hqC=wQmgb_pwaJTdZsj5ceL5fMu1OLKp8wix8M-pPg4tQ@mail.gmail.com>
References: <20200511202046.20515-4-olteanv@gmail.com>
        <20200511154019.216d8aa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+h21hqC=wQmgb_pwaJTdZsj5ceL5fMu1OLKp8wix8M-pPg4tQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 16:11:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 12 May 2020 01:44:53 +0300

> On Tue, 12 May 2020 at 01:40, Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Mon, 11 May 2020 23:20:45 +0300 Vladimir Oltean wrote:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > There are 2 goals that we follow:
>> >
>> > - Reduce the header size
>> > - Make the header size equal between RX and TX
>>
>> Getting this from sparse:
>>
>> ../net/dsa/tag_ocelot.c:185:17: warning: incorrect type in assignment (different base types)
>> ../net/dsa/tag_ocelot.c:185:17:    expected unsigned int [usertype]
>> ../net/dsa/tag_ocelot.c:185:17:    got restricted __be32 [usertype]
> 
> I hate this warning :(

You hate that endianness bugs are caught automatically? :-)

