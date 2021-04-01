Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C1935130C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 12:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhDAKHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 06:07:23 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:51295 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbhDAKHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 06:07:03 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lRuDp-0005br-Lw; Thu, 01 Apr 2021 12:06:41 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lRuDo-000Ffc-EW; Thu, 01 Apr 2021 12:06:40 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id D96B0240041;
        Thu,  1 Apr 2021 12:06:39 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 44BAB240040;
        Thu,  1 Apr 2021 12:06:39 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id BB94C20072;
        Thu,  1 Apr 2021 12:06:38 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 01 Apr 2021 12:06:38 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net: x25: Queue received packets in the
 drivers instead of per-CPU queues
Organization: TDT AG
In-Reply-To: <CAJht_EMVAV1eyredF+VEF=hxTTMVRMx+89XdpVAWpD5Lq1Y9Tw@mail.gmail.com>
References: <20210328221205.726511-1-xie.he.0141@gmail.com>
 <CAJht_EMVAV1eyredF+VEF=hxTTMVRMx+89XdpVAWpD5Lq1Y9Tw@mail.gmail.com>
Message-ID: <21ec9eafa230f2e20dd88d31fd95faa0@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1617271601-0000718E-4D93F7FF/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-31 20:41, Xie He wrote:
> Hi Martin,
> 
> Could you ack this patch again? The only change from the RFC version
> (that you previously acked) is the addition of the "__GFP_NOMEMALLOC"
> flag in "dev_alloc_skb". This is because I want to prevent pfmemalloc
> skbs (which can't be handled by netif_receive_skb_core) from
> occurring.
> 
> Thanks!

Hi!

Sorry for my late answer.
Can you please also fix this line length warning?
https://patchwork.hopto.org/static/nipa/442445/12117801/checkpatch/stdout

- Martin
