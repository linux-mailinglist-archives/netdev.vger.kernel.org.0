Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435A212813C
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLTRSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:18:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55009 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfLTRSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:18:32 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so9681334wmj.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 09:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SxY6IaGmbymedBFWLuP58a/gj3yO0IC9kYzB0PErouw=;
        b=lAnFxUdr2QBT277jxnbTQpdtu2BYHvF6yUr1hvYtdTOum9hXsdiv9MIkH7lHmBumUb
         LF9MLvMXuhi0JBgDBNHYBNH2malGjFa3uYUDiuVgJA+BQcVaLrADTq9tcfH8UcW4ABAi
         /g7CBGARiQP9VFdLd65kk3vsNDnX03Pp7RU2ZwYJVh4CDpLroF6rTLSrUaN4Rx700bJd
         EUeHz5ymegZwOuBEm93gMWakHWHdDT4YXg51znWwgfAXx6w5veqBbYyQDYxkzfrynfr4
         g9oK+bvY+p3HsNFDwgU7IVImdqBnnNGBoviZAXhSoIdbyVmnTw5Gf+5+yyTRDW1zbk0m
         QeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SxY6IaGmbymedBFWLuP58a/gj3yO0IC9kYzB0PErouw=;
        b=CJrheCwARMlem91csThHJt+2NDEPZZPeoHH842vUeayBb+wstG0dWi7vSKPUqlheWG
         Md/5dakcoB/aXZpvNPjICQO2ZV+s1EHNC2tPLIQOnHnE1wX5KWjHH8YVf9JEyQmv/yp7
         MzCBZFrgghQtYYTZZU2Xc5q9RqXrVpicBzI4BPCwRhaHqRQaF1v/BZbM/+/WMBbkZf6L
         kS1Ox/hnMsQvWEU/xk1KocKRh3MtOcckYIzQb1v8W5/3Xya7f7Ce02FqGF5s58nFAOyk
         qThNiPBC6YwSbf5d7b881zoTEAdbCaSYR0MFbcksolwnKNsQKjf4YVqpQ5z/guMqCbrH
         OZ6g==
X-Gm-Message-State: APjAAAWFWt5oIwzvSOdDabxtOyd6SUAQsu+2oGQPVZuDJq7bLFWNcsL/
        iDArtPnNzF0ni0t0iRtaoOOZ4g==
X-Google-Smtp-Source: APXvYqwgG0c44xfFWhnO+UAW06BPipd92pr7ovpVxE67s9gqd5TQU1JtLYVelJAQNG37wWX0Q/3+Gw==
X-Received: by 2002:a1c:7e02:: with SMTP id z2mr18328935wmc.25.1576862306558;
        Fri, 20 Dec 2019 09:18:26 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id x1sm10110504wru.50.2019.12.20.09.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:18:25 -0800 (PST)
Date:   Fri, 20 Dec 2019 12:18:21 -0500
From:   Andy Gospodarek <andy@greyhouse.net>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Andy Roulin <aroulin@cumulusnetworks.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, vfalico@gmail.com
Subject: Re: [PATCH net-next] bonding: rename AD_STATE_* to BOND_3AD_STATE_*
Message-ID: <20191220171821.GA67500@C02YVCJELVCG.dhcp.broadcom.net>
References: <1576798379-5061-1-git-send-email-aroulin@cumulusnetworks.com>
 <20191220155023.GA61232@C02YVCJELVCG.dhcp.broadcom.net>
 <28488.1576859733@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28488.1576859733@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 08:35:33AM -0800, Jay Vosburgh wrote:
> Andy Gospodarek <andy@greyhouse.net> wrote:
> 
> >On Thu, Dec 19, 2019 at 03:32:59PM -0800, Andy Roulin wrote:
> >> As the LACP states are now part of the uapi, rename the
> >> 3ad state defines with BOND_3AD prefix. This way, the naming
> >> is consistent with the the rest of the bonding uapi.
> >
> >Thanks for doing this!
> >
> >> 
> >> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> >> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> >> ---
> >> 
> >> Notes:
> >>     - Most modified lines were already over 80 chars. Some are now over
> >>       80 though but I don't think it would add any values to break them
> >>       to respect the limit.
> >>     
> >>     - Another choice would be LACP_* instead of BOND_3AD_* but going
> >>       with LACP would mean we should replace everywhere 3AD with
> >>       LACP to be consistent.
> >
> >I hate to say this, but I think I prefer the string BOND_8023AD_* or
> >LACP_* to just BOND_3AD_*.  As Jay mentioned the movement a decade ago
> >to 802.1AX also makes me think we should just drop the references to
> >802.3AD all-together and just go with LACP.
> 
> 	I agree; pretty much everything refers to this protocol as LACP
> and not by either the old or current IEEE standard names.
> 
> >You are right that the downside to moving towards LACP_* is that
> >everything should move that way as well, but it seems worthwhile to
> >consider.
> 
> 	But the immediate concern is to get the UAPI correct, as once we
> make public API changes there's no going back later.

Right.

So I'm OK with just a change that adds 'LACP_*' in the place of '*AD_*'
in include/uapi/linux/if_bonding.h and the needed changes across the
rest of the kernel to reflect those changes for now and we can pickup
the rest of the non-uapi changes later.

> 
> 	-J
> 
> >> 
> >>  drivers/net/bonding/bond_3ad.c  | 112 ++++++++++++++++----------------
> >>  include/uapi/linux/if_bonding.h |  16 ++---
> >>  2 files changed, 64 insertions(+), 64 deletions(-)
> >> 
> >> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
> >> index 34bfe99641a3..0b4b8c500894 100644
> >> --- a/drivers/net/bonding/bond_3ad.c
> >> +++ b/drivers/net/bonding/bond_3ad.c
> >> @@ -447,8 +447,8 @@ static void __choose_matched(struct lacpdu *lacpdu, struct port *port)
> >>  	     MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(port->actor_system)) &&
> >>  	     (ntohs(lacpdu->partner_system_priority) == port->actor_system_priority) &&
> >>  	     (ntohs(lacpdu->partner_key) == port->actor_oper_port_key) &&
> >> -	     ((lacpdu->partner_state & AD_STATE_AGGREGATION) == (port->actor_oper_port_state & AD_STATE_AGGREGATION))) ||
> >> -	    ((lacpdu->actor_state & AD_STATE_AGGREGATION) == 0)
> >> +	     ((lacpdu->partner_state & BOND_3AD_STATE_AGGREGATION) == (port->actor_oper_port_state & BOND_3AD_STATE_AGGREGATION))) ||
> >> +	    ((lacpdu->actor_state & BOND_3AD_STATE_AGGREGATION) == 0)
> >>  		) {
> >>  		port->sm_vars |= AD_PORT_MATCHED;
> >>  	} else {
> >> @@ -482,18 +482,18 @@ static void __record_pdu(struct lacpdu *lacpdu, struct port *port)
> >>  		partner->port_state = lacpdu->actor_state;
> >>  
> >>  		/* set actor_oper_port_state.defaulted to FALSE */
> >> -		port->actor_oper_port_state &= ~AD_STATE_DEFAULTED;
> >> +		port->actor_oper_port_state &= ~BOND_3AD_STATE_DEFAULTED;
> >>  
> >>  		/* set the partner sync. to on if the partner is sync,
> >>  		 * and the port is matched
> >>  		 */
> >>  		if ((port->sm_vars & AD_PORT_MATCHED) &&
> >> -		    (lacpdu->actor_state & AD_STATE_SYNCHRONIZATION)) {
> >> -			partner->port_state |= AD_STATE_SYNCHRONIZATION;
> >> +		    (lacpdu->actor_state & BOND_3AD_STATE_SYNCHRONIZATION)) {
> >> +			partner->port_state |= BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			slave_dbg(port->slave->bond->dev, port->slave->dev,
> >>  				  "partner sync=1\n");
> >>  		} else {
> >> -			partner->port_state &= ~AD_STATE_SYNCHRONIZATION;
> >> +			partner->port_state &= ~BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			slave_dbg(port->slave->bond->dev, port->slave->dev,
> >>  				  "partner sync=0\n");
> >>  		}
> >> @@ -516,7 +516,7 @@ static void __record_default(struct port *port)
> >>  		       sizeof(struct port_params));
> >>  
> >>  		/* set actor_oper_port_state.defaulted to true */
> >> -		port->actor_oper_port_state |= AD_STATE_DEFAULTED;
> >> +		port->actor_oper_port_state |= BOND_3AD_STATE_DEFAULTED;
> >>  	}
> >>  }
> >>  
> >> @@ -546,7 +546,7 @@ static void __update_selected(struct lacpdu *lacpdu, struct port *port)
> >>  		    !MAC_ADDRESS_EQUAL(&lacpdu->actor_system, &partner->system) ||
> >>  		    ntohs(lacpdu->actor_system_priority) != partner->system_priority ||
> >>  		    ntohs(lacpdu->actor_key) != partner->key ||
> >> -		    (lacpdu->actor_state & AD_STATE_AGGREGATION) != (partner->port_state & AD_STATE_AGGREGATION)) {
> >> +		    (lacpdu->actor_state & BOND_3AD_STATE_AGGREGATION) != (partner->port_state & BOND_3AD_STATE_AGGREGATION)) {
> >>  			port->sm_vars &= ~AD_PORT_SELECTED;
> >>  		}
> >>  	}
> >> @@ -578,8 +578,8 @@ static void __update_default_selected(struct port *port)
> >>  		    !MAC_ADDRESS_EQUAL(&admin->system, &oper->system) ||
> >>  		    admin->system_priority != oper->system_priority ||
> >>  		    admin->key != oper->key ||
> >> -		    (admin->port_state & AD_STATE_AGGREGATION)
> >> -			!= (oper->port_state & AD_STATE_AGGREGATION)) {
> >> +		    (admin->port_state & BOND_3AD_STATE_AGGREGATION)
> >> +			!= (oper->port_state & BOND_3AD_STATE_AGGREGATION)) {
> >>  			port->sm_vars &= ~AD_PORT_SELECTED;
> >>  		}
> >>  	}
> >> @@ -609,10 +609,10 @@ static void __update_ntt(struct lacpdu *lacpdu, struct port *port)
> >>  		    !MAC_ADDRESS_EQUAL(&(lacpdu->partner_system), &(port->actor_system)) ||
> >>  		    (ntohs(lacpdu->partner_system_priority) != port->actor_system_priority) ||
> >>  		    (ntohs(lacpdu->partner_key) != port->actor_oper_port_key) ||
> >> -		    ((lacpdu->partner_state & AD_STATE_LACP_ACTIVITY) != (port->actor_oper_port_state & AD_STATE_LACP_ACTIVITY)) ||
> >> -		    ((lacpdu->partner_state & AD_STATE_LACP_TIMEOUT) != (port->actor_oper_port_state & AD_STATE_LACP_TIMEOUT)) ||
> >> -		    ((lacpdu->partner_state & AD_STATE_SYNCHRONIZATION) != (port->actor_oper_port_state & AD_STATE_SYNCHRONIZATION)) ||
> >> -		    ((lacpdu->partner_state & AD_STATE_AGGREGATION) != (port->actor_oper_port_state & AD_STATE_AGGREGATION))
> >> +		    ((lacpdu->partner_state & BOND_3AD_STATE_LACP_ACTIVITY) != (port->actor_oper_port_state & BOND_3AD_STATE_LACP_ACTIVITY)) ||
> >> +		    ((lacpdu->partner_state & BOND_3AD_STATE_LACP_TIMEOUT) != (port->actor_oper_port_state & BOND_3AD_STATE_LACP_TIMEOUT)) ||
> >> +		    ((lacpdu->partner_state & BOND_3AD_STATE_SYNCHRONIZATION) != (port->actor_oper_port_state & BOND_3AD_STATE_SYNCHRONIZATION)) ||
> >> +		    ((lacpdu->partner_state & BOND_3AD_STATE_AGGREGATION) != (port->actor_oper_port_state & BOND_3AD_STATE_AGGREGATION))
> >>  		   ) {
> >>  			port->ntt = true;
> >>  		}
> >> @@ -968,7 +968,7 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
> >>  			 * edable port will take place only after this timer)
> >>  			 */
> >>  			if ((port->sm_vars & AD_PORT_SELECTED) &&
> >> -			    (port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) &&
> >> +			    (port->partner_oper.port_state & BOND_3AD_STATE_SYNCHRONIZATION) &&
> >>  			    !__check_agg_selection_timer(port)) {
> >>  				if (port->aggregator->is_active)
> >>  					port->sm_mux_state =
> >> @@ -986,14 +986,14 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
> >>  				port->sm_mux_state = AD_MUX_DETACHED;
> >>  			} else if (port->aggregator->is_active) {
> >>  				port->actor_oper_port_state |=
> >> -				    AD_STATE_SYNCHRONIZATION;
> >> +				    BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			}
> >>  			break;
> >>  		case AD_MUX_COLLECTING_DISTRIBUTING:
> >>  			if (!(port->sm_vars & AD_PORT_SELECTED) ||
> >>  			    (port->sm_vars & AD_PORT_STANDBY) ||
> >> -			    !(port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) ||
> >> -			    !(port->actor_oper_port_state & AD_STATE_SYNCHRONIZATION)) {
> >> +			    !(port->partner_oper.port_state & BOND_3AD_STATE_SYNCHRONIZATION) ||
> >> +			    !(port->actor_oper_port_state & BOND_3AD_STATE_SYNCHRONIZATION)) {
> >>  				port->sm_mux_state = AD_MUX_ATTACHED;
> >>  			} else {
> >>  				/* if port state hasn't changed make
> >> @@ -1022,11 +1022,11 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
> >>  			  port->sm_mux_state);
> >>  		switch (port->sm_mux_state) {
> >>  		case AD_MUX_DETACHED:
> >> -			port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			ad_disable_collecting_distributing(port,
> >>  							   update_slave_arr);
> >> -			port->actor_oper_port_state &= ~AD_STATE_COLLECTING;
> >> -			port->actor_oper_port_state &= ~AD_STATE_DISTRIBUTING;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_COLLECTING;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_DISTRIBUTING;
> >>  			port->ntt = true;
> >>  			break;
> >>  		case AD_MUX_WAITING:
> >> @@ -1035,20 +1035,20 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
> >>  		case AD_MUX_ATTACHED:
> >>  			if (port->aggregator->is_active)
> >>  				port->actor_oper_port_state |=
> >> -				    AD_STATE_SYNCHRONIZATION;
> >> +				    BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			else
> >>  				port->actor_oper_port_state &=
> >> -				    ~AD_STATE_SYNCHRONIZATION;
> >> -			port->actor_oper_port_state &= ~AD_STATE_COLLECTING;
> >> -			port->actor_oper_port_state &= ~AD_STATE_DISTRIBUTING;
> >> +				    ~BOND_3AD_STATE_SYNCHRONIZATION;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_COLLECTING;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_DISTRIBUTING;
> >>  			ad_disable_collecting_distributing(port,
> >>  							   update_slave_arr);
> >>  			port->ntt = true;
> >>  			break;
> >>  		case AD_MUX_COLLECTING_DISTRIBUTING:
> >> -			port->actor_oper_port_state |= AD_STATE_COLLECTING;
> >> -			port->actor_oper_port_state |= AD_STATE_DISTRIBUTING;
> >> -			port->actor_oper_port_state |= AD_STATE_SYNCHRONIZATION;
> >> +			port->actor_oper_port_state |= BOND_3AD_STATE_COLLECTING;
> >> +			port->actor_oper_port_state |= BOND_3AD_STATE_DISTRIBUTING;
> >> +			port->actor_oper_port_state |= BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			ad_enable_collecting_distributing(port,
> >>  							  update_slave_arr);
> >>  			port->ntt = true;
> >> @@ -1146,7 +1146,7 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
> >>  				port->sm_vars |= AD_PORT_LACP_ENABLED;
> >>  			port->sm_vars &= ~AD_PORT_SELECTED;
> >>  			__record_default(port);
> >> -			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_EXPIRED;
> >>  			port->sm_rx_state = AD_RX_PORT_DISABLED;
> >>  
> >>  			/* Fall Through */
> >> @@ -1156,9 +1156,9 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
> >>  		case AD_RX_LACP_DISABLED:
> >>  			port->sm_vars &= ~AD_PORT_SELECTED;
> >>  			__record_default(port);
> >> -			port->partner_oper.port_state &= ~AD_STATE_AGGREGATION;
> >> +			port->partner_oper.port_state &= ~BOND_3AD_STATE_AGGREGATION;
> >>  			port->sm_vars |= AD_PORT_MATCHED;
> >> -			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_EXPIRED;
> >>  			break;
> >>  		case AD_RX_EXPIRED:
> >>  			/* Reset of the Synchronization flag (Standard 43.4.12)
> >> @@ -1167,19 +1167,19 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
> >>  			 * case of EXPIRED even if LINK_DOWN didn't arrive for
> >>  			 * the port.
> >>  			 */
> >> -			port->partner_oper.port_state &= ~AD_STATE_SYNCHRONIZATION;
> >> +			port->partner_oper.port_state &= ~BOND_3AD_STATE_SYNCHRONIZATION;
> >>  			port->sm_vars &= ~AD_PORT_MATCHED;
> >> -			port->partner_oper.port_state |= AD_STATE_LACP_TIMEOUT;
> >> -			port->partner_oper.port_state |= AD_STATE_LACP_ACTIVITY;
> >> +			port->partner_oper.port_state |= BOND_3AD_STATE_LACP_TIMEOUT;
> >> +			port->partner_oper.port_state |= BOND_3AD_STATE_LACP_ACTIVITY;
> >>  			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(AD_SHORT_TIMEOUT));
> >> -			port->actor_oper_port_state |= AD_STATE_EXPIRED;
> >> +			port->actor_oper_port_state |= BOND_3AD_STATE_EXPIRED;
> >>  			port->sm_vars |= AD_PORT_CHURNED;
> >>  			break;
> >>  		case AD_RX_DEFAULTED:
> >>  			__update_default_selected(port);
> >>  			__record_default(port);
> >>  			port->sm_vars |= AD_PORT_MATCHED;
> >> -			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_EXPIRED;
> >>  			break;
> >>  		case AD_RX_CURRENT:
> >>  			/* detect loopback situation */
> >> @@ -1192,8 +1192,8 @@ static void ad_rx_machine(struct lacpdu *lacpdu, struct port *port)
> >>  			__update_selected(lacpdu, port);
> >>  			__update_ntt(lacpdu, port);
> >>  			__record_pdu(lacpdu, port);
> >> -			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(port->actor_oper_port_state & AD_STATE_LACP_TIMEOUT));
> >> -			port->actor_oper_port_state &= ~AD_STATE_EXPIRED;
> >> +			port->sm_rx_timer_counter = __ad_timer_to_ticks(AD_CURRENT_WHILE_TIMER, (u16)(port->actor_oper_port_state & BOND_3AD_STATE_LACP_TIMEOUT));
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_EXPIRED;
> >>  			break;
> >>  		default:
> >>  			break;
> >> @@ -1221,7 +1221,7 @@ static void ad_churn_machine(struct port *port)
> >>  	if (port->sm_churn_actor_timer_counter &&
> >>  	    !(--port->sm_churn_actor_timer_counter) &&
> >>  	    port->sm_churn_actor_state == AD_CHURN_MONITOR) {
> >> -		if (port->actor_oper_port_state & AD_STATE_SYNCHRONIZATION) {
> >> +		if (port->actor_oper_port_state & BOND_3AD_STATE_SYNCHRONIZATION) {
> >>  			port->sm_churn_actor_state = AD_NO_CHURN;
> >>  		} else {
> >>  			port->churn_actor_count++;
> >> @@ -1231,7 +1231,7 @@ static void ad_churn_machine(struct port *port)
> >>  	if (port->sm_churn_partner_timer_counter &&
> >>  	    !(--port->sm_churn_partner_timer_counter) &&
> >>  	    port->sm_churn_partner_state == AD_CHURN_MONITOR) {
> >> -		if (port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) {
> >> +		if (port->partner_oper.port_state & BOND_3AD_STATE_SYNCHRONIZATION) {
> >>  			port->sm_churn_partner_state = AD_NO_CHURN;
> >>  		} else {
> >>  			port->churn_partner_count++;
> >> @@ -1288,7 +1288,7 @@ static void ad_periodic_machine(struct port *port)
> >>  
> >>  	/* check if port was reinitialized */
> >>  	if (((port->sm_vars & AD_PORT_BEGIN) || !(port->sm_vars & AD_PORT_LACP_ENABLED) || !port->is_enabled) ||
> >> -	    (!(port->actor_oper_port_state & AD_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & AD_STATE_LACP_ACTIVITY))
> >> +	    (!(port->actor_oper_port_state & BOND_3AD_STATE_LACP_ACTIVITY) && !(port->partner_oper.port_state & BOND_3AD_STATE_LACP_ACTIVITY))
> >>  	   ) {
> >>  		port->sm_periodic_state = AD_NO_PERIODIC;
> >>  	}
> >> @@ -1305,11 +1305,11 @@ static void ad_periodic_machine(struct port *port)
> >>  			switch (port->sm_periodic_state) {
> >>  			case AD_FAST_PERIODIC:
> >>  				if (!(port->partner_oper.port_state
> >> -				      & AD_STATE_LACP_TIMEOUT))
> >> +				      & BOND_3AD_STATE_LACP_TIMEOUT))
> >>  					port->sm_periodic_state = AD_SLOW_PERIODIC;
> >>  				break;
> >>  			case AD_SLOW_PERIODIC:
> >> -				if ((port->partner_oper.port_state & AD_STATE_LACP_TIMEOUT)) {
> >> +				if ((port->partner_oper.port_state & BOND_3AD_STATE_LACP_TIMEOUT)) {
> >>  					port->sm_periodic_timer_counter = 0;
> >>  					port->sm_periodic_state = AD_PERIODIC_TX;
> >>  				}
> >> @@ -1325,7 +1325,7 @@ static void ad_periodic_machine(struct port *port)
> >>  			break;
> >>  		case AD_PERIODIC_TX:
> >>  			if (!(port->partner_oper.port_state &
> >> -			    AD_STATE_LACP_TIMEOUT))
> >> +			    BOND_3AD_STATE_LACP_TIMEOUT))
> >>  				port->sm_periodic_state = AD_SLOW_PERIODIC;
> >>  			else
> >>  				port->sm_periodic_state = AD_FAST_PERIODIC;
> >> @@ -1532,7 +1532,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
> >>  	ad_agg_selection_logic(aggregator, update_slave_arr);
> >>  
> >>  	if (!port->aggregator->is_active)
> >> -		port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
> >> +		port->actor_oper_port_state &= ~BOND_3AD_STATE_SYNCHRONIZATION;
> >>  }
> >>  
> >>  /* Decide if "agg" is a better choice for the new active aggregator that
> >> @@ -1838,13 +1838,13 @@ static void ad_initialize_port(struct port *port, int lacp_fast)
> >>  		port->actor_port_priority = 0xff;
> >>  		port->actor_port_aggregator_identifier = 0;
> >>  		port->ntt = false;
> >> -		port->actor_admin_port_state = AD_STATE_AGGREGATION |
> >> -					       AD_STATE_LACP_ACTIVITY;
> >> -		port->actor_oper_port_state  = AD_STATE_AGGREGATION |
> >> -					       AD_STATE_LACP_ACTIVITY;
> >> +		port->actor_admin_port_state = BOND_3AD_STATE_AGGREGATION |
> >> +					       BOND_3AD_STATE_LACP_ACTIVITY;
> >> +		port->actor_oper_port_state  = BOND_3AD_STATE_AGGREGATION |
> >> +					       BOND_3AD_STATE_LACP_ACTIVITY;
> >>  
> >>  		if (lacp_fast)
> >> -			port->actor_oper_port_state |= AD_STATE_LACP_TIMEOUT;
> >> +			port->actor_oper_port_state |= BOND_3AD_STATE_LACP_TIMEOUT;
> >>  
> >>  		memcpy(&port->partner_admin, &tmpl, sizeof(tmpl));
> >>  		memcpy(&port->partner_oper, &tmpl, sizeof(tmpl));
> >> @@ -2095,10 +2095,10 @@ void bond_3ad_unbind_slave(struct slave *slave)
> >>  		  aggregator->aggregator_identifier);
> >>  
> >>  	/* Tell the partner that this port is not suitable for aggregation */
> >> -	port->actor_oper_port_state &= ~AD_STATE_SYNCHRONIZATION;
> >> -	port->actor_oper_port_state &= ~AD_STATE_COLLECTING;
> >> -	port->actor_oper_port_state &= ~AD_STATE_DISTRIBUTING;
> >> -	port->actor_oper_port_state &= ~AD_STATE_AGGREGATION;
> >> +	port->actor_oper_port_state &= ~BOND_3AD_STATE_SYNCHRONIZATION;
> >> +	port->actor_oper_port_state &= ~BOND_3AD_STATE_COLLECTING;
> >> +	port->actor_oper_port_state &= ~BOND_3AD_STATE_DISTRIBUTING;
> >> +	port->actor_oper_port_state &= ~BOND_3AD_STATE_AGGREGATION;
> >>  	__update_lacpdu_from_port(port);
> >>  	ad_lacpdu_send(port);
> >>  
> >> @@ -2685,9 +2685,9 @@ void bond_3ad_update_lacp_rate(struct bonding *bond)
> >>  	bond_for_each_slave(bond, slave, iter) {
> >>  		port = &(SLAVE_AD_INFO(slave)->port);
> >>  		if (lacp_fast)
> >> -			port->actor_oper_port_state |= AD_STATE_LACP_TIMEOUT;
> >> +			port->actor_oper_port_state |= BOND_3AD_STATE_LACP_TIMEOUT;
> >>  		else
> >> -			port->actor_oper_port_state &= ~AD_STATE_LACP_TIMEOUT;
> >> +			port->actor_oper_port_state &= ~BOND_3AD_STATE_LACP_TIMEOUT;
> >>  	}
> >>  	spin_unlock_bh(&bond->mode_lock);
> >>  }
> >> diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
> >> index 6829213a54c5..0fc5d5ae8f09 100644
> >> --- a/include/uapi/linux/if_bonding.h
> >> +++ b/include/uapi/linux/if_bonding.h
> >> @@ -96,14 +96,14 @@
> >>  #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
> >>  
> >>  /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
> >> -#define AD_STATE_LACP_ACTIVITY   0x1
> >> -#define AD_STATE_LACP_TIMEOUT    0x2
> >> -#define AD_STATE_AGGREGATION     0x4
> >> -#define AD_STATE_SYNCHRONIZATION 0x8
> >> -#define AD_STATE_COLLECTING      0x10
> >> -#define AD_STATE_DISTRIBUTING    0x20
> >> -#define AD_STATE_DEFAULTED       0x40
> >> -#define AD_STATE_EXPIRED         0x80
> >> +#define BOND_3AD_STATE_LACP_ACTIVITY   0x1
> >> +#define BOND_3AD_STATE_LACP_TIMEOUT    0x2
> >> +#define BOND_3AD_STATE_AGGREGATION     0x4
> >> +#define BOND_3AD_STATE_SYNCHRONIZATION 0x8
> >> +#define BOND_3AD_STATE_COLLECTING      0x10
> >> +#define BOND_3AD_STATE_DISTRIBUTING    0x20
> >> +#define BOND_3AD_STATE_DEFAULTED       0x40
> >> +#define BOND_3AD_STATE_EXPIRED         0x80
> >>  
> >>  typedef struct ifbond {
> >>  	__s32 bond_mode;
> >> -- 
> >> 2.20.1
> >> 
