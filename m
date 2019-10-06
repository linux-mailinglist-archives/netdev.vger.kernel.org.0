Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C348CD389
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 18:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfJFQcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 12:32:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45152 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfJFQcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 12:32:42 -0400
Received: from localhost (unknown [8.46.76.29])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2134145AE067;
        Sun,  6 Oct 2019 09:32:35 -0700 (PDT)
Date:   Sun, 06 Oct 2019 18:32:29 +0200 (CEST)
Message-Id: <20191006.183229.346887230501537659.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] mlxsw: Query number of modules from
 firmware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191006063452.7666-1-idosch@idosch.org>
References: <20191006063452.7666-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 09:32:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun,  6 Oct 2019 09:34:47 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Vadim says:
> 
> The patchset adds support for a new field "num_of_modules" of Management
> General Peripheral Information Register (MGPIR), providing the maximum
> number of QSFP modules, which can be supported by the system.
> 
> It allows to obtain the number of QSFP modules directly from this field,
> as a static data, instead of old method of getting this info through
> "network port to QSFP module" mapping. With the old method, in case of
> port dynamic re-configuration some modules can logically "disappear" as
> a result of port split operations, which can cause some modules to
> appear missing.
> 
> Such scenario can happen on a system equipped with a BMC card, while PCI
> chip driver at host CPU side can perform some ports "split" or "unsplit"
> operations, while BMC side I2C chip driver reads the "port-to-module"
> mapping.
> 
> Add common API for FW "minor" and "subminor" versions validation and
> share it between PCI and I2C based drivers.
> 
> Add FW version validation for "minimal" driver, because use of new field
> "num_of_modules" in MGPIR register is not backward compatible.

Looks good, series applied.
