Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022C623141
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 12:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbfETKY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 06:24:28 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35158 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbfETKY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 06:24:28 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hSfT0-0007Ka-4K; Mon, 20 May 2019 12:24:26 +0200
Date:   Mon, 20 May 2019 12:24:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 net-next] ip: add a new parameter -Numeric
Message-ID: <20190520102426.GM4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20190520075648.15882-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520075648.15882-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, May 20, 2019 at 03:56:48PM +0800, Hangbin Liu wrote:
> When calles rtnl_dsfield_n2a(), we get the dsfield name from
> /etc/iproute2/rt_dsfield. But different distribution may have
> different names. So add a new parameter '-Numeric' to only show
> the dsfield number.
> 
> This parameter is only used for tos value at present. We could enable
> this for other fields if needed in the future.

Rationale is to ensure expected output irrespective of host
configuration, especially in test scripts. Concrete example motivating
this patch was net/fib_rule_tests.sh in kernel self-tests.

> Suggested-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks for doing this, Hangbin!

Phil
