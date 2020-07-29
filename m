Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DF223169A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbgG2AHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgG2AHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:07:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E9C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:07:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40824128D3053;
        Tue, 28 Jul 2020 16:50:49 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:07:33 -0700 (PDT)
Message-Id: <20200728.170733.50204252309115397.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, kubakici@wp.pl, jiri@resnulli.us,
        tom@herbertland.com, jiri@mellanox.com, kuba@kernel.org
Subject: Re: [net-next v1 0/5] introduce PLDM firmware update library
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200724002203.451621-1-jacob.e.keller@intel.com>
References: <20200724002203.451621-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:50:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu, 23 Jul 2020 17:21:58 -0700

> This series goal is to enable support for updating the ice hardware flash
> using the devlink flash command.
> 
> The ice firmware update files are distributed using the file format
> described by the "PLDM for Firmware Update" standard:
> 
> https://www.dmtf.org/documents/pmci/pldm-firmware-update-specification-100
> 
> Because this file format is standard, this series introduces a new library
> that handles the generic logic for parsing the PLDM file header. The library
> uses a design that is very similar to the Mellanox mlxfw module. That is, a
> simple ops table is setup and device drivers instantiate an instance of the
> pldmfw library with the device specific operations.
> 
> Doing so allows for each device to implement the low level behavior for how
> to interact with its firmware.
> 
> This series includes the library and an implementation for the ice hardware.
> I've removed all of the parameters, and the proposed changes to support
> overwrite mode. I'll be working on the overwrite mask suggestion from Jakub
> as a follow-up series.
> 
> Because the PLDM file format is a standard and not something that is
> specific to the Intel hardware, I opted to place this update library in
> lib/pldmfw. I should note that while I tried to make the library generic, it
> does not attempt to mimic the complete "Update Agent" as defined in the
> standard. This is mostly due to the fact that the actual interfaces exposed
> to software for the ice hardware would not allow this.
> 
> This series depends on some work just recently and is based on top of the
> patch series sent by Tony published at:
> 
> https://lore.kernel.org/netdev/20200723234720.1547308-1-anthony.l.nguyen@intel.com/T/#t
 ...

Series applied, thanks.
