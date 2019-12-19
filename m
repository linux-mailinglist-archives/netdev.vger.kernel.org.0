Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B660126341
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 14:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfLSNRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 08:17:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46002 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfLSNRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 08:17:15 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1ihvfq-0003cf-84; Thu, 19 Dec 2019 08:17:09 -0500
Date:   Thu, 19 Dec 2019 08:17:00 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191219131700.GA1159@hmswarspite.think-freely.org>
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191213114934.GB5449@hmswarspite.think-freely.org>
 <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKD1Yr1m-bqpeZxMRVs84WvvjRE3zp8kJVx57OXf342r2gzVyw@mail.gmail.com>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 06:35:13PM +0900, Lorenzo Colitti wrote:
> On Fri, 13 Dec 2019, 20:49 Neil Horman, <nhorman@tuxdriver.com> wrote:
> > Just out of curiosity, why are the portreserve and portrelease utilities not a
> > solution to this use case?
> 
> As I understand it, those utilities keep the ports reserved by binding
> to them so that no other process can. This doesn't work for Android
> because there are conformance tests that probe the device from the
> network and check that there are no open ports.
> 
But you can address that with some augmentation to portreserve (i.e. just have
it add an iptables rule to drop frames on that port, or respond with a port
unreachable icmp message)

Neil

