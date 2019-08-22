Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7701198A00
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbfHVDtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:49:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfHVDtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:49:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FC92151A20BB;
        Wed, 21 Aug 2019 20:49:49 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:49:48 -0700 (PDT)
Message-Id: <20190821.204948.907885435812375741.davem@davemloft.net>
To:     h.feurstein@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, richardcochran@gmail.com, mlichvar@redhat.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, olteanv@gmail.com, fugang.duan@nxp.com
Subject: Re: [PATCH net-next v3 0/4] Improve phc2sys precision for
 mv88e6xxx switch in combination with imx6-fec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820084833.6019-1-hubert.feurstein@vahle.at>
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:49:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>
Date: Tue, 20 Aug 2019 10:48:29 +0200

> From: Hubert Feurstein <h.feurstein@gmail.com>
> 
> Changelog:
>  v3: mv88e6xxx_smi_indirect_write: forward ptp_sts only on the last write
>      Copied Miroslav Lichvar because of PTP offset compensation patch
>  v2: Added patch for PTP offset compensation
>      Removed mdiobus_write_sts as there was no user
>      Removed ptp_sts_supported-boolean and introduced flags instead
> 
> With this patchset the phc2sys synchronisation precision improved to +/-555ns on
> an IMX6DL with an MV88E6220 switch attached.
> 
> This patchset takes into account the comments from the following discussions:
> - https://lkml.org/lkml/2019/8/2/1364
> - https://lkml.org/lkml/2019/8/5/169
> 
> Patch 01 adds the required infrastructure in the MDIO layer.
> Patch 02 adds additional PTP offset compensation.
> Patch 03 adds support for the PTP_SYS_OFFSET_EXTENDED ioctl in the mv88e6xxx driver.
> Patch 04 adds support for the PTP system timestamping in the imx-fec driver.

It looks like there is still some active discussion about these changes and
there will likely be another spin.
