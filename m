Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E586DE893
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 02:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDLAsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 20:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDLAsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 20:48:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C530FD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kHQim5c/4/xC2azJUvVTgYntji52qxcNbd+g4lp621g=; b=zQoljsfyaLdQG0F6DyiTz1QtrL
        4q87NSYgx8rhxGjiHqmIBV9vUKk5qVHBXL4eY5eSmXHCU7Yo6weZWfwEPe4Nzn1B2Ndz3ke82ilmh
        YGejo9khN/Yk3Js5cuEp0BbbukAhfEhs30vq8CFhppjEe3yY7W2nPCvCGdcZM7xe2GAs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmOf5-00A2Sh-FP; Wed, 12 Apr 2023 02:48:35 +0200
Date:   Wed, 12 Apr 2023 02:48:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407141451.133048-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:14:49PM +0300, Vladimir Oltean wrote:
> This series introduces the "dsa" trace event class, with the following
> events:
> 
> $ trace-cmd list | grep dsa
> dsa
> dsa:dsa_fdb_add_hw
> dsa:dsa_mdb_add_hw
> dsa:dsa_fdb_del_hw
> dsa:dsa_mdb_del_hw
> dsa:dsa_fdb_add_bump
> dsa:dsa_mdb_add_bump
> dsa:dsa_fdb_del_drop
> dsa:dsa_mdb_del_drop
> dsa:dsa_fdb_del_not_found
> dsa:dsa_mdb_del_not_found
> dsa:dsa_lag_fdb_add_hw
> dsa:dsa_lag_fdb_add_bump
> dsa:dsa_lag_fdb_del_hw
> dsa:dsa_lag_fdb_del_drop
> dsa:dsa_lag_fdb_del_not_found
> dsa:dsa_vlan_add_hw
> dsa:dsa_vlan_del_hw
> dsa:dsa_vlan_add_bump
> dsa:dsa_vlan_del_drop
> dsa:dsa_vlan_del_not_found
> 
> These are useful to debug refcounting issues on CPU and DSA ports, where
> entries may remain lingering, or may be removed too soon, depending on
> bugs in higher layers of the network stack.

Hi Vladimir

I don't know anything about trace points. Should you Cc: 

Steven Rostedt <rostedt@goodmis.org> (maintainer:TRACING)
Masami Hiramatsu <mhiramat@kernel.org> (maintainer:TRACING)

to get some feedback from people who do?

   Andrew
