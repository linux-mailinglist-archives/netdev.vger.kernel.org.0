Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B372D53CF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 07:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgLJG3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 01:29:13 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:43367 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733306AbgLJG3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 01:29:13 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1knFQ9-0005Ng-FX; Thu, 10 Dec 2020 07:27:21 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1knFQ8-0005gS-CG; Thu, 10 Dec 2020 07:27:20 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 3FCA8240041;
        Thu, 10 Dec 2020 07:27:19 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id B3410240040;
        Thu, 10 Dec 2020 07:27:18 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 0884B202DE;
        Thu, 10 Dec 2020 07:27:18 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Dec 2020 07:27:17 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v7 4/5] net/x25: fix restart request/confirm
 handling
Organization: TDT AG
In-Reply-To: <CAJht_EPj-4bv6D=Ojz5KCbk0NTVfjRyEA3NmMw7etxrq8GKu8Q@mail.gmail.com>
References: <20201126063557.1283-1-ms@dev.tdt.de>
 <20201126063557.1283-5-ms@dev.tdt.de>
 <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
 <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com>
 <3e314d2786857cbd5aaee8b83a0e6daa@dev.tdt.de>
 <CAJht_ENOhnS7A6997CAP5qhn10NMYSVD3xOxcbPGQFLGb8z_Sg@mail.gmail.com>
 <CAJht_EPj-4bv6D=Ojz5KCbk0NTVfjRyEA3NmMw7etxrq8GKu8Q@mail.gmail.com>
Message-ID: <458f89938c565b82fe30087fb33602b9@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1607581641-00000FB8-BB3A271E/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 23:11, Xie He wrote:
> On Wed, Dec 9, 2020 at 1:47 AM Xie He <xie.he.0141@gmail.com> wrote:
>> 
>> On Wed, Dec 9, 2020 at 1:41 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> >
>> > Right.
>> > By the way: A "Restart Collision" is in practice a very common event to
>> > establish the Layer 3.
>> 
>> Oh, I see. Thanks!
> 
> Hi Martin,
> 
> When you submit future patch series, can you try ensuring the code to
> be in a completely working state after each patch in the series? This
> makes reviewing the patches easier. After the patches get applied,
> this also makes tracing bugs (for example, with "git bisect") through
> the commit history easier.

Well I thought that's what patch series are for:
Send patches that belong together and should be applied together.

Of course I will try to make each patch work on its own, but this is not
always possible with major changes or ends up in monster patches.
And nobody wants that.

Martin
