Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C402C5101F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbfFXPQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:16:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfFXPQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:16:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B38815044B7E;
        Mon, 24 Jun 2019 08:15:58 -0700 (PDT)
Date:   Mon, 24 Jun 2019 08:15:57 -0700 (PDT)
Message-Id: <20190624.081557.1496651956585483806.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, vadimp@mellanox.com,
        andrew@lunn.ch, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 0/3] mlxsw: Thermal and hwmon extensions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624103203.22090-1-idosch@idosch.org>
References: <20190624103203.22090-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 08:16:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 24 Jun 2019 13:32:00 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset from Vadim includes various enhancements to thermal and
> hwmon code in mlxsw.
> 
> Patch #1 adds a thermal zone for each inter-connect device (gearbox).
> These devices are present in SN3800 systems and code to expose their
> temperature via hwmon was added in commit 2e265a8b6c09 ("mlxsw: core:
> Extend hwmon interface with inter-connect temperature attributes").
> 
> Currently, there are multiple thermal zones in mlxsw and only a few
> cooling devices. Patch #2 detects the hottest thermal zone and the
> cooling devices are switched to follow its trends. RFC was sent last
> month [1].
> 
> Patch #3 allows to read and report negative temperature of the sensors
> mlxsw exposes via hwmon and thermal subsystems.
> 
> v2 (Andrew Lunn):
> * In patch #3, replace '%u' with '%d' in mlxsw_hwmon_module_temp_show()
> 
> [1] https://patchwork.ozlabs.org/patch/1107161/

Series applied, thanks.
