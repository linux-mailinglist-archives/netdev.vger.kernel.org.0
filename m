Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBFC16B5A2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgBXXbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:31:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbgBXXbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:31:49 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA8DF124CE3EA;
        Mon, 24 Feb 2020 15:31:47 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:31:46 -0800 (PST)
Message-Id: <20200224.153146.125327154283545636.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     jeremy.linton@arm.com, netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 0/6] Add ACPI bindings to the genet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5cc69c8e-69e0-0ee6-af1f-3fb22df957ca@gmail.com>
References: <20200224225403.1650656-1-jeremy.linton@arm.com>
        <5cc69c8e-69e0-0ee6-af1f-3fb22df957ca@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:31:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 24 Feb 2020 15:09:36 -0800

> On 2/24/20 2:53 PM, Jeremy Linton wrote:
>> This patch series allows the BCM GENET, as used on the RPi4,
>> to attach when booted in an ACPI environment. The DSDT entry to
>> trigger this is seen below. Of note, the first patch adds a
>> small extension to the mdio layer which allows drivers to find
>> the mii_bus without firmware assistance. The fifth patch in
>> the set retrieves the MAC address from the umac registers
>> rather than carrying it directly in the DSDT. This of course
>> requires the firmware to pre-program it, so we continue to fall
>> back on a random one if it appears to be garbage.
> 
> Thanks for your persistence on this I was able to apply this to the
> latest net-next tree and give this a spin on a STB chip (which uses DT)
> and did not see any issues, so:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Series applied, thanks everyone.
