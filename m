Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428A014FA1F
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgBATKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:10:46 -0500
Received: from foss.arm.com ([217.140.110.172]:43418 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgBATKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:10:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7052FFEC;
        Sat,  1 Feb 2020 11:10:45 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21FD93F68E;
        Sat,  1 Feb 2020 11:10:45 -0800 (PST)
Subject: Re: [PATCH 2/6] net: bcmgenet: refactor phy mode configuration
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-3-jeremy.linton@arm.com>
 <b2d45990-af71-60c3-a210-b23dabb9ba32@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <1c8f6931-8c69-fecb-8a95-9107dfb7ade0@arm.com>
Date:   Sat, 1 Feb 2020 13:10:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b2d45990-af71-60c3-a210-b23dabb9ba32@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for taking a look at this again!

On 2/1/20 10:24 AM, Florian Fainelli wrote:
> 
> 
> On 1/31/2020 11:46 PM, Jeremy Linton wrote:
>> The DT phy mode is similar to what we want for ACPI
>> lets factor it out of the of path, and change the
>> of_ call to device_. Further if the phy-mode property
>> cannot be found instead of failing the driver load lets
>> just default it to RGMII.
> 
> Humm no please do not provide a fallback, if we cannot find a valid
> 'phy-mode' property we error out. This controller can be used with a
> variety of configurations (internal EPHY/GPHY, MoCA, external
> MII/Reverse MII/RGMII) and from a support perspective it is much easier
> for us if the driver errors out if one of those essential properties are
> omitted.
> 
> Other than that, this looks OK.
> 

Sure, I went around in circles about this one because it cluttered the 
code path up a bit.

