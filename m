Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFFD2794DE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgIYXpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIYXpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:45:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D50C0613CE;
        Fri, 25 Sep 2020 16:45:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F22613BA0728;
        Fri, 25 Sep 2020 16:28:24 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:45:10 -0700 (PDT)
Message-Id: <20200925.164510.467198062051144115.davem@davemloft.net>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] vmxnet3: fix cksum offload issues for non-udp
 tunnels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925061130.9017-1-doshir@vmware.com>
References: <20200925061130.9017-1-doshir@vmware.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:28:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>
Date: Thu, 24 Sep 2020 23:11:29 -0700

> Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support") added support for encapsulation offload. However, the inner
> offload capability is to be restrictued to UDP tunnels.
> 
> This patch fixes the issue for non-udp tunnels by adding features
> check capability and filtering appropriate features for non-udp tunnels.
> 
> Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>

Applied and queued up for -stable, thanks.
