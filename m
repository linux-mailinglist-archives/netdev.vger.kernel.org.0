Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B321E706A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437542AbgE1X1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437484AbgE1X1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:27:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B0EC08C5C6;
        Thu, 28 May 2020 16:27:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DFCE1296CF84;
        Thu, 28 May 2020 16:27:11 -0700 (PDT)
Date:   Thu, 28 May 2020 16:27:08 -0700 (PDT)
Message-Id: <20200528.162708.2161599947641716831.davem@davemloft.net>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/4] vmxnet3: upgrade to version 4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528215322.31682-1-doshir@vmware.com>
References: <20200528215322.31682-1-doshir@vmware.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 16:27:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>
Date: Thu, 28 May 2020 14:53:18 -0700

> vmxnet3 emulation has recently added several new features which includes
> offload support for tunnel packets, support for new commands the driver
> can issue to emulation, change in descriptor fields, etc. This patch
> series extends the vmxnet3 driver to leverage these new features.
> 
> Compatibility is maintained using existing vmxnet3 versioning mechanism as
> follows:
>  - new features added to vmxnet3 emulation are associated with new vmxnet3
>    version viz. vmxnet3 version 4.
>  - emulation advertises all the versions it supports to the driver.
>  - during initialization, vmxnet3 driver picks the highest version number
>  supported by both the emulation and the driver and configures emulation
>  to run at that version.
> 
> In particular, following changes are introduced:
> 
> Patch 1:
>   This patch introduces utility macros for vmxnet3 version 4 comparison
>   and updates Copyright information.
> 
> Patch 2:
>   This patch implements get_rss_hash_opts and set_rss_hash_opts methods
>   to allow querying and configuring different Rx flow hash configurations
>   which can be used to support UDP/ESP RSS.
> 
> Patch 3:
>   This patch introduces segmentation and checksum offload support for
>   encapsulated packets. This avoids segmenting and calculating checksum
>   for each segment and hence gives performance boost.
> 
> Patch 4:
>   With all vmxnet3 version 4 changes incorporated in the vmxnet3 driver,
>   with this patch, the driver can configure emulation to run at vmxnet3
>   version 4.
> 
> Changes in v3 -> v4:
>    - Replaced BUG_ON() with WARN_ON_ONCE()
 ...

Series applied, thanks.
