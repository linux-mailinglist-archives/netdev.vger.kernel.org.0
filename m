Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73F84540D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfFNFf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:35:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfFNFfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:35:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F57E14DD4FDE;
        Thu, 13 Jun 2019 22:35:55 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:35:54 -0700 (PDT)
Message-Id: <20190613.223554.2063466506595237097.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 0/9] mlxsw: Add support for physical
 hardware clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:35:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 11 Jun 2019 18:45:03 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Shalom says:
> 
> This patchset adds support for physical hardware clock for Spectrum-1
> ASIC only.
> 
> Patches #1, #2 and #3 add the ability to query the free running clock
> PCI address.
> 
> Patches #4 and #5 add two new register, the Management UTC Register and
> the Management Pulse Per Second Register.
> 
> Patch #6 publishes scaled_ppm_to_ppb() to allow drivers to use it.
> 
> Patch #7 adds the physical hardware clock operations.
> 
> Patch #8 initializes the physical hardware clock.
> 
> Patch #9 adds a selftest for testing the PTP physical hardware clock.
> 
> v2 (Richard):
> * s/ptp_clock_scaled_ppm_to_ppb/scaled_ppm_to_ppb/
> * imply PTP_1588_CLOCK in mlxsw Kconfig
> * s/mlxsw_sp1_ptp_update_phc_settime/mlxsw_sp1_ptp_phc_settime/
> * s/mlxsw_sp1_ptp_update_phc_adjfreq/mlxsw_sp1_ptp_phc_adjfreq/

Series applied, thanks.
