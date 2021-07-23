Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0F73D396B
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhGWKob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhGWKoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:44:30 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDC1C061575;
        Fri, 23 Jul 2021 04:25:04 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BF891221E6;
        Fri, 23 Jul 2021 13:25:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627039502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fszxqKXDPtHSocdLQaBQmiEK73CDVbhWM36B8VGWOU0=;
        b=eoAn61Mc/sXonKaf+4euIyA4sVsR8ZdWsIk3M0RkNvc+TBoKeJOyS0Ui3S6C/GnxtfBbU5
        9VP428iFyhBTUtb3YpNMgJoJJdJF6cMBzK5KTb2l2aohOQ6duBaXC6jeV1LCsP8FDO5LN9
        yXGoE0oepfrmZwilzU+RSOouxH4j7uo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 23 Jul 2021 13:25:02 +0200
From:   Michael Walle <michael@walle.cc>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, vivien.didelot@gmail.com
Subject: Re: [RFC] dsa: register every port with of_platform
In-Reply-To: <YPqlmyvU2IjPFkXC@Ansuel-xps.localdomain>
References: <20210723110505.9872-1-ansuelsmth@gmail.com>
 <20210723111328.20949-1-michael@walle.cc>
 <YPqlmyvU2IjPFkXC@Ansuel-xps.localdomain>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <168cb1440ebe1cff4a7b5e343502638a@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-07-23 13:18, schrieb Ansuel Smith:
> On Fri, Jul 23, 2021 at 01:13:28PM +0200, Michael Walle wrote:
>> > The declaration of a different mac-addr using the nvmem framework is
>> > currently broken. The dsa code uses the generic of_get_mac_address where
>> > the nvmem function requires the device node to be registered in the
>> > of_platform to be found by of_find_device_by_node. Register every port
>> 
>> Which tree are you on? This should be fixed with
>> 
>> f10843e04a07  of: net: fix of_get_mac_addr_nvmem() for non-platform 
>> devices
>> 
>> -michael
> 
> Thx a lot for the hint. So yes I missed that the problem was already
> fixed. Sorry for the mess. Any idea if that will be backported?

I didn't include a Fixes tag, so it won't be automatically
backported. Also I'm not sure if it qualifies for the stable trees
because no in-tree users seem to be affected, no?

-michael
