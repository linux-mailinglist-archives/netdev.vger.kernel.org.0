Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE0354CA3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhDFGSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:18:10 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:42135 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhDFGSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:18:08 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lTf2A-0000fP-GV; Tue, 06 Apr 2021 08:17:54 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lTf29-000Gsq-4z; Tue, 06 Apr 2021 08:17:53 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 7A345240041;
        Tue,  6 Apr 2021 08:17:52 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id D1975240040;
        Tue,  6 Apr 2021 08:17:51 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 3851120046;
        Tue,  6 Apr 2021 08:17:51 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Apr 2021 08:17:51 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v5] net: x25: Queue received packets in the
 drivers instead of per-CPU queues
Organization: TDT AG
In-Reply-To: <CAJht_EO7ufuRPj2Bbp7PyXbBT+jrpxR2pckT9JOPyve_tWj9DA@mail.gmail.com>
References: <20210402093000.72965-1-xie.he.0141@gmail.com>
 <CAJht_EO7ufuRPj2Bbp7PyXbBT+jrpxR2pckT9JOPyve_tWj9DA@mail.gmail.com>
Message-ID: <f77ea411add46de10d1b9e72576a0ec2@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1617689873-000063FF-11509F12/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-05 21:34, Xie He wrote:
> Hi Martin,
> 
> Could you ack? Thanks!

Acked-by: Martin Schiller <ms@dev.tdt.de>

Just for the record: I'm certainly not always the fastest,
but I don't work holidays or weekends. So you also need to have some
patience.

