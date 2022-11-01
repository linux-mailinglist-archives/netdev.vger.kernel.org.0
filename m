Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52526152B1
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 21:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiKAUFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 16:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAUFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 16:05:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6F61C437;
        Tue,  1 Nov 2022 13:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LEq/aBrq9Dkaeu3yr9tLk3Wh8ERxZDVGhiSFuxa4GZ8=; b=JMOqRF/atib0J2b7g2l8/DPRun
        0ipGenUKgVCKc7IgAOhHWWO5Qvg68zBNhrZd9C1UfaYb/NtybqbqTmVkKhAPr5/BHwGDlLn5r/gnu
        qM2h3ycUdTyl/i6UmHdqgmEOHI2FNaEUE00WZXfr9BfhDPfCc3Yz0dTg4SEnB7cUaqbU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opxUl-0018b1-Az; Tue, 01 Nov 2022 21:04:23 +0100
Date:   Tue, 1 Nov 2022 21:04:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwm.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev
Subject: Re: [PATCH net-next] netconsole: Enable live renaming for network
 interfaces used by netconsole
Message-ID: <Y2F7x319oanq/+i1@lunn.ch>
References: <20221101181225.1272144-1-andy.ren@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101181225.1272144-1-andy.ren@getcruise.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     where
>  	+             if present, enable extended console support
>  	src-port      source for UDP packets (defaults to 6665)
>  	src-ip        source IP to use (interface address)
>  	dev           network interface (eth0)
> +	*             if present, allow runtime network interface renaming
>  	tgt-port      port for logging agent (6666)
>  	tgt-ip        IP address for logging agent
>  	tgt-macaddr   ethernet MAC address for logging agent (broadcast)
>  
>  Examples::
>  
> - linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
> + linux netconsole=4444@10.0.0.1/eth1*,9353@10.0.0.2/12:34:56:78:9a:bc

To me, this looks like a wildcard of the interface name.

Maybe move the position of the *. Put it after the + ?

      Andrew
