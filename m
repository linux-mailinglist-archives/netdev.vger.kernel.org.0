Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5216EFE8C
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbjD0AeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjD0AeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:34:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAE326A8
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 17:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+RNLXpMbynbSm6lA+FT6uOwD2PTilBdNHcgvGXs8Ymc=; b=pBpsRVWCz3ZQKncsx/RIQUuMsV
        +pIo7xxK4KyDoFNE14ul7IhDxSPVF9Ht9/o03HVyeZh72uw114MhFBP0Xv3OxBdU/FJIrJUn6DBOm
        rp3bcDJVoIgCLlUDYnjBj/2HvplPHHPWun+4bS+zpKQNrAd3VXuGQXl80b9uTT4aA7Ro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prpa8-00BJYV-Ra; Thu, 27 Apr 2023 02:33:56 +0200
Date:   Thu, 27 Apr 2023 02:33:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <2f150ad4-34f4-4af9-b3ce-c1aff208ec7e@lunn.ch>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
 <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
 <20230412095534.dh2iitmi3j5i74sv@skbuf>
 <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
 <20230421124708.tznoutsymiirqja2@skbuf>
 <20230424182554.642bc0fc@rorschach.local.home>
 <20230426191336.kucul56wa4p7topa@skbuf>
 <20230426152345.327a429d@gandalf.local.home>
 <20230426194301.mtw2d5ooi3ywtxad@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426194301.mtw2d5ooi3ywtxad@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Well, there's one thing that could become useful for tooling, and
> that's determining the resource utilization of the hardware (number of
> dsa_fdb_add_hw events minus dsa_fdb_del_hw, number of dsa_vlan_add_hw
> minus dsa_vlan_del_hw, etc) relative to some hardcoded maximum capacity
> which would be somehow determined by userspace for each driver. There
> have been requests for this in the not so distant past.

That sounds similar to devlink resources. The mv88e6xxx driver already
returns the number of entries in the ATU, and the size of the
ATU. Maybe that just needs generalising?

     Andrew
