Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6FEA3CD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfJ3THW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:07:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44544 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfJ3THW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:07:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD22A149AF4D3;
        Wed, 30 Oct 2019 12:07:21 -0700 (PDT)
Date:   Wed, 30 Oct 2019 12:07:21 -0700 (PDT)
Message-Id: <20191030.120721.1153122137511744800.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v2 0/4] mlxsw: Update firmware version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030093451.26325-1-idosch@idosch.org>
References: <20191030093451.26325-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 12:07:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 30 Oct 2019 11:34:47 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set updates the firmware version for Spectrum-1 and enforces
> a firmware version for Spectrum-2.
> 
> The version adds support for querying port module type. It will be used
> by a followup patch set from Jiri to make port split code more generic.
> 
> Patch #1 increases the size of an existing register in order to be
> compatible with the new firmware version. In the future the firmware
> will assign default values to fields not specified by the driver.
> 
> Patch #2 temporarily increases the PCI reset timeout for SN3800 systems.
> Note that in normal cases the driver will need to wait no longer than 5
> seconds for the device to become ready following reset command.
> 
> Patch #3 bumps the firmware version for Spectrum-1.
> 
> Patch #4 enforces a minimum firmware version for Spectrum-2.
> 
> v2:
> * Added patch #2

Series applied, thanks Ido.
