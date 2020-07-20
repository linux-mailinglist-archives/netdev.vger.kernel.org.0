Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127B92255E0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 04:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgGTCYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 22:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgGTCYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 22:24:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A28C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 19:24:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88FDE12864453;
        Sun, 19 Jul 2020 19:24:02 -0700 (PDT)
Date:   Sun, 19 Jul 2020 19:24:01 -0700 (PDT)
Message-Id: <20200719.192401.1110272100468125745.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        jacob.e.keller@intel.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next 0/3] Fully describe the waveform for PTP
 periodic output
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716224531.1040140-1-olteanv@gmail.com>
References: <20200716224531.1040140-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 19:24:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 17 Jul 2020 01:45:28 +0300

> While using the ancillary pin functionality of PTP hardware clocks to
> synchronize multiple DSA switches on a board, a need arised to be able
> to configure the duty cycle of the master of this PPS hierarchy.
> 
> Also, the PPS master is not able to emit PPS starting from arbitrary
> absolute times, so a new flag is introduced to support such hardware
> without making guesses.
> 
> With these patches, struct ptp_perout_request now basically describes a
> general-purpose square wave.
> 
> Changes in v2:
> Made sure this applies to net-next.

Series applied, thank you.
