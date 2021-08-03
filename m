Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640D63DF300
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhHCQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbhHCQmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:42:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51935C061799
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:42:36 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mAxUt-0008Tk-CN; Tue, 03 Aug 2021 18:42:31 +0200
Date:   Tue, 3 Aug 2021 18:42:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     David Ahern <dsahern@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [iproute PATCH] tc: u32: Fix key folding in sample option
Message-ID: <20210803164231.GF3673@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210202183051.21022-1-phil@nwl.cc>
 <20210705141740.GI3673@orbyte.nwl.cc>
 <12ac420d-1b04-9338-03bf-b18ce2d71dcf@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12ac420d-1b04-9338-03bf-b18ce2d71dcf@mojatatu.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

On Mon, Jul 05, 2021 at 01:25:21PM -0400, Jamal Hadi Salim wrote:
> On 2021-07-05 10:17 a.m., Phil Sutter wrote:
[...]
> > Seems this patch fell off the table? Or was there an objection I missed?
> > 
> 
> None i am aware of. I did ACK the patch.

Could you please consider applying this patch? I am aware this is a fix
and therefore shouldn't have to go via iproute2-next but it's almost a
month since I pinged Stephen and didn't receive a reply.

Thanks, Phil
