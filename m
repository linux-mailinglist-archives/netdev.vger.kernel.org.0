Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17821302DF
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfE3Tg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:36:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfE3Tgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:36:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E6AA14DA893D;
        Thu, 30 May 2019 12:36:55 -0700 (PDT)
Date:   Thu, 30 May 2019 12:36:54 -0700 (PDT)
Message-Id: <20190530.123654.773645789138003217.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/8] mlxsw: Hardware monitoring enhancements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:36:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 29 May 2019 11:47:14 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset from Vadim provides various hardware monitoring related
> improvements for mlxsw.
> 
> Patch #1 allows querying firmware version from the switch driver when
> the underlying bus is I2C. This is useful for baseboard management
> controller (BMC) systems that communicate with the ASIC over I2C.
> 
> Patch #2 improves driver's performance over I2C by utilizing larger
> transactions sizes, if possible.
> 
> Patch #3 re-orders driver's initialization sequence to enforce a
> specific firmware version before new firmware features are utilized.
> This is a prerequisite for patches #4-#6.
> 
> Patches #4-#6 expose the temperature of inter-connect devices
> (gearboxes) that are present in Mellanox SN3800 systems and split
> 2x50Gb/s lanes to 4x25Gb/s lanes.
> 
> Patches #7-#8 reduce the transaction size when reading SFP modules
> temperatures, which is crucial when working over I2C.

Series applied, thanks.
