Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC17C66A
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfGaPYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:24:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbfGaPYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:24:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 040C412665369;
        Wed, 31 Jul 2019 08:24:17 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:24:12 -0700 (PDT)
Message-Id: <20190731.082412.820196099656249955.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Two small fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731063315.9381-1-idosch@idosch.org>
References: <20190731063315.9381-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:24:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 31 Jul 2019 09:33:13 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 from Jiri fixes the error path of the module initialization
> function. Found during manual code inspection.
> 
> Patch #2 from Petr further reduces the default shared buffer pool sizes
> in order to work around a problem that was originally described in
> commit e891ce1dd2a5 ("mlxsw: spectrum_buffers: Reduce pool size on
> Spectrum-2").

Series applied and queued up for -stable, thanks.
