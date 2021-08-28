Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1383FA7BC
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhH1V47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 17:56:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhH1V46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 17:56:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vp90gTxy96WUsrqchSv866KBvrTfoMBmU07VqL1PZDU=; b=pFNZ1Nu/pRKiZ8dYQMUI1E+P4w
        bCkfzHDm8y7N3jee/wtEYZTw+5Bqc21DrSXu7cG4ezTkqilFfLhY2cJEbaLZHXxVPkLs8pD1Y7n8Y
        YOxyQaLsookS4Mqw3aHpxKhEAHw/RH4leKn2hkWGevq6f1qQl46vbrmxfY50SK5mNRFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mK6Ir-004KCG-Ij; Sat, 28 Aug 2021 23:55:53 +0200
Date:   Sat, 28 Aug 2021 23:55:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE message
 to get SyncE status
Message-ID: <YSqw6aJRrWbxRaas@lunn.ch>
References: <20210828211248.3337476-1-maciej.machnikowski@intel.com>
 <20210828211248.3337476-2-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828211248.3337476-2-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 28, 2021 at 11:12:47PM +0200, Maciej Machnikowski wrote:
> This patch adds the new RTM_GETSYNCESTATE message to query the status
> of SyncE syntonization on the device.

Hi Maciej

You use syntonization a few times. Is this a miss spelling for
synchronisation, or a SyncE terms?

> @@ -193,7 +196,7 @@ enum {
>  #define RTM_NR_FAMILIES	(RTM_NR_MSGTYPES >> 2)
>  #define RTM_FAM(cmd)	(((cmd) - RTM_BASE) >> 2)
>  
> -/* 
> +/*
>     Generic structure for encapsulation of optional route information.
>     It is reminiscent of sockaddr, but with sa_family replaced
>     with attribute type.
> @@ -233,7 +236,7 @@ struct rtmsg {
>  
>  	unsigned char		rtm_table;	/* Routing table id */
>  	unsigned char		rtm_protocol;	/* Routing protocol; see below	*/
> -	unsigned char		rtm_scope;	/* See below */	
> +	unsigned char		rtm_scope;	/* See below */
>  	unsigned char		rtm_type;	/* See below	*/
>  
>  	unsigned		rtm_flags;
> @@ -555,7 +558,7 @@ struct ifinfomsg {
>  };
>  
>  /********************************************************************
> - *		prefix information 
> + *		prefix information
>   ****/
>  
>  struct prefixmsg {
> @@ -569,7 +572,7 @@ struct prefixmsg {
>  	unsigned char	prefix_pad3;
>  };
>  
> -enum 
> +enum
>  {
>  	PREFIX_UNSPEC,
>  	PREFIX_ADDRESS,

You appear to have a number of white space changes here. Please put
them into a separate patch, or drop them.

     Andrew
