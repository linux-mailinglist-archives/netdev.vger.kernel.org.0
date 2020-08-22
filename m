Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B549724E9EA
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 23:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHVVBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 17:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgHVVBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 17:01:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7FC061573;
        Sat, 22 Aug 2020 14:01:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA91E12767ECE;
        Sat, 22 Aug 2020 13:44:55 -0700 (PDT)
Date:   Sat, 22 Aug 2020 14:01:41 -0700 (PDT)
Message-Id: <20200822.140141.880909883327091452.davem@davemloft.net>
To:     kalou@tfz.net
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, akpm@linux-foundation.org,
        adobriyan@gmail.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 2/2] net: socket: implement SO_DESCRIPTION
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAGbU3_krnjbeKnm6Zyn-tqYCHVZFBkB+oCP-UF_kVOGz=zkKFQ@mail.gmail.com>
References: <CAGbU3_nRMbe8Syo3OHw6B4LXUheGiXXcLcaEQe0EAFTAB7xgng@mail.gmail.com>
        <CAGbU3_=ZywUOP1CKNQ6=P99SgX28_0iXSs81yP=vGFKv7JyMcQ@mail.gmail.com>
        <CAGbU3_krnjbeKnm6Zyn-tqYCHVZFBkB+oCP-UF_kVOGz=zkKFQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 13:44:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pascal Bouchareine <kalou@tfz.net>
Date: Sat, 22 Aug 2020 13:53:03 -0700

> On Sat, Aug 22, 2020 at 1:19 PM Pascal Bouchareine <kalou@tfz.net> wrote:
>>
>> On Sat, Aug 22, 2020 at 12:59 PM Pascal Bouchareine <kalou@tfz.net> wrote:
>>
>> > Would it make sense to also make UDIAG_SHOW_NAME use sk_description?
>> > (And keep the existing change - setsockopt + show_fd_info via
>> > /proc/.../fdinfo/..)
>>
>>
>> Ah,very wrong example - to be more precise, I suppose that'd be adding
>> a couple idiag_ext for sk_description and pid if possible instead
> 
> About the pid part -
> On top of multiple pids to scan for a given socket, there's also the
> security provided by /proc - I'm not sure what inet_diag does for that
> So maybe users calling it will need to scan /proc for a long time anyway...
> 
> Or is that doable?

I'd like to kindly ask that you do more research into how this kind of
information is advertised to the user using modern interfaces, and what
kinds of permissions and checks are done for those.

You are proposing a new UAPI for the Linux kernel, and with that comes
some level of responsibility.

Thank you.
