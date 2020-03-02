Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C572175603
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgCBIcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:32:17 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:9718 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCBIcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583137932;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=dyg4AOlIJyThsXs5J5Vubyx8MvOEPr/tJdn+Z7Tzl30=;
        b=Id7nbtg+bd/uBH6QyVcwkPLXlxW3cVLXzWepNrnbeLDLgRIA/EB7nnQ04B0y6gqK3A
        sze/QRUMMxv7sTggtuXpF1M5IUvPySeErAab+XnbZNH/HdocR0ASLd1iQyi2qbPgRnlp
        BdWQD9mWQbRaPzh/+55BEp+msSopaNx1kYhQQaTt4lP7XY0ZryfsoeN0KBZ950Krf37H
        9GJQbQEY/rTEfYlabDahCId8l3X7nmYuIjUwj0w596Ox6RJUG11cCP3n/1wYd5rvDbLL
        /QTfkDk/Qo+XHOlmjor5gclTXr+71R8MBpq01YUie5ENt4IfGp5Jx1cP3Ctne3anabls
        IiCw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVMh6kEtw"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id e0a4ffw228W255z
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 2 Mar 2020 09:32:02 +0100 (CET)
Subject: Re: KASAN: use-after-free Read in slcan_open
To:     syzbot <syzbot+b5ec6fd05ab552a78532@syzkaller.appspotmail.com>,
        davem@davemloft.net, dvyukov@google.com, jouni.hogander@unikie.com,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wg@grandegger.com
References: <00000000000099fb63059fd95165@google.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <2f8c5b49-ae02-e269-97cf-b4a979f950ac@hartkopp.net>
Date:   Mon, 2 Mar 2020 09:31:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <00000000000099fb63059fd95165@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#sys fix: can: slcan: Fix use-after-free Read in slcan_open

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/can/slcan.c?id=9ebd796e24008f33f06ebea5a5e6aceb68b51794

Thanks,
Oliver

On 02/03/2020 07.30, syzbot wrote:
> This bug is marked as fixed by commit:
> slcan: Fix use-after-free Read in slcan_open
> But I can't find it in any tested tree for more than 90 days.
> Is it a correct commit? Please update it by replying:
> #syz fix: exact-commit-title
> Until then the bug is still considered open and
> new crashes with the same signature are ignored.
> 
