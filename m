Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564C2263509
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgIIRxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIIRxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:53:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B661DC061573;
        Wed,  9 Sep 2020 10:53:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 029361294CC3B;
        Wed,  9 Sep 2020 10:36:58 -0700 (PDT)
Date:   Wed, 09 Sep 2020 10:53:44 -0700 (PDT)
Message-Id: <20200909.105344.700560545234457454.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: b53: Report VLAN table occupancy
 via devlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909160337.fp4i5hhryr2by54m@skbuf>
References: <20200909043235.4080900-1-f.fainelli@gmail.com>
        <20200909160337.fp4i5hhryr2by54m@skbuf>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 10:36:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 9 Sep 2020 19:03:37 +0300

> On Tue, Sep 08, 2020 at 09:32:34PM -0700, Florian Fainelli wrote:
>> @@ -977,6 +977,53 @@ int b53_get_sset_count(struct dsa_switch *ds, int port, int sset)
>>  }
>>  EXPORT_SYMBOL(b53_get_sset_count);
>>  
>> +enum b53_devlink_resource_id {
>> +	B53_DEVLINK_PARMA_ID_VLAN_TABLE,
> 
> Parma is a city in Italy, maybe PARAM?

:-))) Agreed.
