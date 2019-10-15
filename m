Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E80D71FA
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfJOJTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 05:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15811 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfJOJTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 05:19:15 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 912F2309BDBC;
        Tue, 15 Oct 2019 09:19:14 +0000 (UTC)
Received: from ovpn-116-35.ams2.redhat.com (ovpn-116-35.ams2.redhat.com [10.36.116.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2647519C7F;
        Tue, 15 Oct 2019 09:19:11 +0000 (UTC)
Message-ID: <5ba8b82764c8b51744f9c77355c2c917e9206d19.camel@redhat.com>
Subject: Re: [PATCH net] sunrpc: fix UDP memory accounting for v4.4 kernel
From:   Paolo Abeni <pabeni@redhat.com>
To:     JABLONSKY Jan <Jan.JABLONSKY@thalesgroup.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Trond Myklebust <trond.myklebust@primarydata.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>
Date:   Tue, 15 Oct 2019 11:19:11 +0200
In-Reply-To: <e5070c6d6157290c2a3f627a50d951ca141973b1.camel@thalesgroup.com>
References: <e5070c6d6157290c2a3f627a50d951ca141973b1.camel@thalesgroup.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 15 Oct 2019 09:19:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2019-10-15 at 07:21 +0000, JABLONSKY Jan wrote:
> The same warnings reported by Jan Stancek may appear also on 4.4
> Based on Paolo Abeni's work.
> 
> WARNING: at net/ipv4/af_inet.c:155
> CPU: 1 PID: 214 Comm: kworker/1:1H Not tainted 4.4.166 #1
> Workqueue: rpciod .xprt_autoclose
> task: c0000000366f57c0 ti: c000000034134000 task.ti: c000000034134000
> NIP [c000000000662268] .inet_sock_destruct+0x158/0x200
> 
> Based on: "[net] sunrpc: fix UDP memory accounting"

Since your goal here is the inclusion into the 4.4.y stable tree, you
should follow the instructions listed here:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

elsewhere I guess your patch will not be processed properly. The
relevant commit message is merged into Linus tree since some time and
some minor modifications are needed, so you may likely follow option 3.

Cheers,

Paolo

