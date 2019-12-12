Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BEE11D6C5
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfLLTFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:05:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730168AbfLLTFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:05:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC42D153DFC99;
        Thu, 12 Dec 2019 11:05:13 -0800 (PST)
Date:   Thu, 12 Dec 2019 11:05:13 -0800 (PST)
Message-Id: <20191212.110513.1770889236741616001.davem@davemloft.net>
To:     pdurrant@amazon.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org
Subject: Re: [PATCH net-next] xen-netback: get rid of old udev related code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212135406.26229-1-pdurrant@amazon.com>
References: <20191212135406.26229-1-pdurrant@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 11:05:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>
Date: Thu, 12 Dec 2019 13:54:06 +0000

> In the past it used to be the case that the Xen toolstack relied upon
> udev to execute backend hotplug scripts. However this has not been the
> case for many releases now and removal of the associated code in
> xen-netback shortens the source by more than 100 lines, and removes much
> complexity in the interaction with the xenstore backend state.
> 
> NOTE: xen-netback is the only xenbus driver to have a functional uevent()
>       method. The only other driver to have a method at all is
>       pvcalls-back, and currently pvcalls_back_uevent() simply returns 0.
>       Hence this patch also facilitates further cleanup.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

If userspace ever used this stuff, I seriously doubt you can remove this
even if it hasn't been used in 5+ years.

Sorry.
