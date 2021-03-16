Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1168433D733
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbhCPPSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:18:21 -0400
Received: from mxout70.expurgate.net ([194.37.255.70]:36427 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbhCPPSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:18:11 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lMBSG-0005UI-Kj; Tue, 16 Mar 2021 16:17:56 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1lMBSF-0007b7-Lu; Tue, 16 Mar 2021 16:17:55 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E40F9240041;
        Tue, 16 Mar 2021 16:17:54 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 69D9F240040;
        Tue, 16 Mar 2021 16:17:54 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id BD73620072;
        Tue, 16 Mar 2021 16:17:53 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 16 Mar 2021 16:17:53 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking whether
 the netif is running
Organization: TDT AG
In-Reply-To: <CAJht_ENT6E4pekdTJ8YKntKdH94e-1H6Tf6iBr-=Vbxj5rCs+A@mail.gmail.com>
References: <20210311072311.2969-1-xie.he.0141@gmail.com>
 <CAJht_ENT6E4pekdTJ8YKntKdH94e-1H6Tf6iBr-=Vbxj5rCs+A@mail.gmail.com>
Message-ID: <111a4642c8ae3c9e0d9f271fe7c54e86@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1615907876-00000E25-329F2CA6/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-14 02:59, Xie He wrote:
> Hi Martin,
> 
> Could you ack? Thanks!

Acked-by: Martin Schiller <ms@dev.tdt.de>
