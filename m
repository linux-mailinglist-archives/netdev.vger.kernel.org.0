Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E076BDCC62
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505282AbfJRRND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:13:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388893AbfJRRNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:13:02 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1912414A9086A;
        Fri, 18 Oct 2019 10:13:02 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:13:01 -0400 (EDT)
Message-Id: <20191018.131301.29161421832947467.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] selftests: mlxsw: Add scale tests for
 Spectrum-2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017065518.27008-1-idosch@idosch.org>
References: <20191017065518.27008-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 10:13:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 17 Oct 2019 09:55:13 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This series from Danielle adds two scale tests for the Spectrum-2 ASIC.
> 
> The first scale test (patches #1-#4) validates the number of mirroring
> sessions (using tc-mirred) that can be supported by the device. As a
> preparatory step, patch #1 exposes the maximum number and current usage
> of mirroring agents via devlink-resource. This allows us to avoid
> hard-coding the limits later in the test.
> 
> The second scale test (patch #5) validates the number of tc-flower
> filters that can be supported by the device.

Series applied, thanks Ido.
