Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862721B7CC
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbfEMOH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:07:57 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60932 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728500AbfEMOH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 10:07:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hQBcC-0001Ug-VP; Mon, 13 May 2019 16:07:41 +0200
Date:   Mon, 13 May 2019 16:07:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Weilong Chen <chenweilong@huawei.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] ipv4: Add support to disable icmp timestamp
Message-ID: <20190513140740.czxevllgv3s4h3cm@breakpoint.cc>
References: <1557754137-100816-1-git-send-email-chenweilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557754137-100816-1-git-send-email-chenweilong@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Weilong Chen <chenweilong@huawei.com> wrote:
> The remote host answers to an ICMP timestamp request.
> This allows an attacker to know the time and date on your host.

No, it does not, I already told you so in V1 :-/

If you really think that its a problem that one can discover
milliseconds-since-midnight please just change inet_current_timestamp()
to add a random offset instead of adding yet another sysctl.
