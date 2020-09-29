Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2863E27D7C1
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgI2UMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbgI2UMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:12:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3C3C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 13:12:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1403E14554265;
        Tue, 29 Sep 2020 12:55:35 -0700 (PDT)
Date:   Tue, 29 Sep 2020 13:12:21 -0700 (PDT)
Message-Id: <20200929.131221.1027274950196920779.davem@davemloft.net>
To:     skardach@marvell.com
Cc:     kuba@kernel.org, sgoutham@marvell.com, netdev@vger.kernel.org,
        kda@semihalf.com
Subject: Re: [PATCH net-next 0/7] octeontx2-af: cleanup and extend parser
 config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 29 Sep 2020 12:55:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>
Date: Tue, 29 Sep 2020 11:28:13 +0200

> Current KPU configuration data is spread over multiple files which makes
> it hard to read. Clean this up by gathering all configuration data in a
> single structure and also in a single file (npc_profile.h). This should
> increase the readability of KPU handling code (since it always
> references same structure), simplify updates to the CAM key extraction
> code and allow abstracting out the configuration source.
> Additionally extend and fix the parser config to support additional DSA
> types, NAT-T-ESP and IPv6 fields.
> 
> Patch 1 ensures that CUSTOMx LTYPEs are not aliased with meaningful
> LTYPEs where possible.
> 
> Patch 2 gathers all KPU profile related data into a single struct and
> creates an adapter structure which provides an interface to the KPU
> profile for the octeontx2-af driver.
> 
> Patches 3-4 add support for Extended DSA, eDSA and Forward DSA.
> 
> Patches 5-6 adds IPv6 fields to CAM key extraction and optimize the
> parser performance for fragmented IPv6 packets.
> 
> Patch 7 refactors ESP handling in the parser to support NAT-T-ESP.

This looks fine, series applied, thanks.
