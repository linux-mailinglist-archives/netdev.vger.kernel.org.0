Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5262B3F48
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgKPI7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:59:32 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:57569 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgKPI7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:59:32 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keaM9-0006M0-Jy; Mon, 16 Nov 2020 09:59:25 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keaM7-00087T-Ic; Mon, 16 Nov 2020 09:59:23 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E63B4240049;
        Mon, 16 Nov 2020 09:59:22 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 68378240047;
        Mon, 16 Nov 2020 09:59:22 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 2137D20438;
        Mon, 16 Nov 2020 09:59:22 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Nov 2020 09:59:22 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] net/x25: add/remove x25_link_device by
 NETDEV_REGISTER/UNREGISTER
Organization: TDT AG
In-Reply-To: <CAJht_ENxZhW9MK_HsY_6c_VjUbubQCYZwkVMYbHL-4aWJkaxuQ@mail.gmail.com>
References: <20201116073149.23219-1-ms@dev.tdt.de>
 <CAJht_ENxZhW9MK_HsY_6c_VjUbubQCYZwkVMYbHL-4aWJkaxuQ@mail.gmail.com>
Message-ID: <10f8c81543962df2e35a54c08387c74e@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1605517165-000064E4-61D9A38E/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-16 09:45, Xie He wrote:
> Hi Martin,
> 
> Thanks for the series. To get the series applied faster, could you
> address the warnings and failures shown on this page?
> https://patchwork.kernel.org/project/netdevbpf/list/?submitter=174539
> Thanks!
> 
> To let the netdev robot know which tree this series should be applied,
> we can use [PATCH net-next 1/6] as the subject prefix.

Hi Xie!

Thanks. I will have a look at this.
