Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB75C5725BF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiGLTjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbiGLTjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDDE116F91;
        Tue, 12 Jul 2022 12:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5F56190D;
        Tue, 12 Jul 2022 19:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82903C3411C;
        Tue, 12 Jul 2022 19:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657653343;
        bh=3yTTQie8DtqaKd9ZTir5dp14zJdkYiaLfviztCz9+RQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yeWzGgcr8jpZCWqITFCrhwgC4z9CJogZRt79kuF0CddGmHpyrBkPOi/O1Zoh1Y6o/
         /IB0gcX7uZilkDK9R3iOJ4xalbd34j+EsGnAz3YXdUjkuZzydcvr8LZWbCqv2RdvV4
         L1lFkAlpOlGATnF+JXWK5DEIjU+Isyk9MG8mheQc=
Date:   Tue, 12 Jul 2022 21:14:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     longli@microsoft.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <Ys3IM6S3nbT0NFs0@kroah.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 07:07:20PM -0700, longli@linuxonhyperv.com wrote:
> --- /dev/null
> +++ b/drivers/infiniband/hw/mana/cq.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB

Why perpetuate this mess that the OpenIB people created?  I thought that
no new drivers were going to be added with this, why does this one need
to have it as well if it is new?

thanks,

greg k-h
