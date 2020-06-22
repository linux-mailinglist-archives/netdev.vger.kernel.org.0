Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68365203F61
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgFVSox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:44:53 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:58032 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbgFVSox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:44:53 -0400
Received: from [192.168.178.106] (p57bc9787.dip0.t-ipconnect.de [87.188.151.135])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 8AA8042B84D;
        Mon, 22 Jun 2020 18:44:51 +0000 (UTC)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
Date:   Mon, 22 Jun 2020 20:44:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622184115.GE405672@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20 8:41 PM, Andrew Lunn wrote:
> On Mon, Jun 22, 2020 at 08:34:43PM +0200, Daniel Mack wrote:
>> Ports with internal PHYs that are not in 'fixed-link' mode are currently
>> only set up once at startup with a static config. Attempts to change the
>> link speed or duplex settings are currently prevented by an early bail
>> in mv88e6xxx_mac_config(). As the default config forces the speed to
>> 1000M, setups with reduced link speed on such ports are unsupported.
> 
> Hi Daniel
> 
> How are you trying to change the speed?

With ethtool for instance. But all userspace tools are bailing out early
on this port for the reason I described.


Thanks,
Daniel
