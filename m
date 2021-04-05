Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E252B3541FA
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 14:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhDEMPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 08:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233156AbhDEMPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 08:15:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04505613A9;
        Mon,  5 Apr 2021 12:15:13 +0000 (UTC)
Date:   Mon, 5 Apr 2021 14:15:10 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH] net: Allow to specify ifindex when device is moved to
 another namespace
Message-ID: <20210405121510.zvfqkuxk56oncaxk@wittgenstein>
References: <20210402073622.1260310-1-avagin@gmail.com>
 <20210405071223.138101-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210405071223.138101-1-avagin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 12:12:23AM -0700, Andrei Vagin wrote:
> Currently, we can specify ifindex on link creation. This change allows
> to specify ifindex when a device is moved to another network namespace.
> 
> Even now, a device ifindex can be changed if there is another device
> with the same ifindex in the target namespace. So this change doesn't
> introduce completely new behavior, it adds more control to the process.
> 
> CRIU users want to restore containers with pre-created network devices.
> A user will provide network devices and instructions where they have to
> be restored, then CRIU will restore network namespaces and move devices
> into them. The problem is that devices have to be restored with the same
> indexes that they have before C/R.
> 
> Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> ---

LGTM.
Thank for doing this!
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
