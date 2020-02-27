Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A073172945
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgB0UKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:10:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44816 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbgB0UKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:10:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25C7E12199AD6;
        Thu, 27 Feb 2020 12:10:31 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:10:30 -0800 (PST)
Message-Id: <20200227.121030.348000556990403150.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net] mlxsw: pci: Wait longer before accessing the
 device after reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227200753.22235-1-jiri@resnulli.us>
References: <20200227200753.22235-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 12:10:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 27 Feb 2020 21:07:53 +0100

> From: Amit Cohen <amitc@mellanox.com>
> 
> During initialization the driver issues a reset to the device and waits
> for 100ms before checking if the firmware is ready. The waiting is
> necessary because before that the device is irresponsive and the first
> read can result in a completion timeout.
> 
> While 100ms is sufficient for Spectrum-1 and Spectrum-2, it is
> insufficient for Spectrum-3.
> 
> Fix this by increasing the timeout to 200ms.
> 
> Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thanks Jiri.

