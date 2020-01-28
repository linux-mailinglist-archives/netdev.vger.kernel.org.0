Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0736C14B1E1
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 10:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgA1JmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 04:42:22 -0500
Received: from ozlabs.org ([203.11.71.1]:43971 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgA1JmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 04:42:22 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 486M8n0TCyz9s29;
        Tue, 28 Jan 2020 20:42:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1580204538;
        bh=vBYxluI8YO3d0BkpCpGleyVdqs3TLmw/qUXpjpvWwkw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=StHYXGkmWl/RXHUl1ZItf4Zf1jmM0t9S9lc+nB3PNyfnS77Fh0FLFoQyHKz+RQw16
         XNcYb94YF/w/m0dUHHw/1aWvo4YYUurLj38VhZbIK8ya2IIlNYbB/x3Le9Vjt8KnCP
         7yNoxlBtQ7I1kwfp1x4/hpHIEWbtR5tHtkB8jF08a+IKt6TyHHuHwBnMFoY4c5ubdU
         gXO/xuRY7x5MWd/QZmjKypaOHlEUEdodTvtFdgDkNFMLSci1wv+7gH1cO0ndl2eidR
         bbCVzzYX2Syyf7bNow953LVleA8hhw2EWMy224lS5ZNDTyxuDhuIIN8Vnmhj4feNEV
         PjE04twgQ38Qw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com, vishal@chelsio.com
Subject: Re: [PATCH] net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM
In-Reply-To: <7a7d18d3-8c8d-af05-9aa0-fa54fa0dc0b7@cogentembedded.com>
References: <20200124094144.15831-1-mpe@ellerman.id.au> <7a7d18d3-8c8d-af05-9aa0-fa54fa0dc0b7@cogentembedded.com>
Date:   Tue, 28 Jan 2020 20:42:16 +1100
Message-ID: <87lfprhq87.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:
> Hello!
>
> On 24.01.2020 12:41, Michael Ellerman wrote:
>
>> The cxgb3 driver for "Chelsio T3-based gigabit and 10Gb Ethernet
>> adapters" implements a custom ioctl as SIOCCHIOCTL/SIOCDEVPRIVATE in
>> cxgb_extension_ioctl().
>> 
>> One of the subcommands of the ioctl is CHELSIO_GET_MEM, which appears
>> to read memory directly out of the adapter and return it to userspace.
>> It's not entirely clear what the contents of the adapter memory
>> contains, but the assumption is that it shouldn't be accessible to all
>
>     s/contains/is/? Else it sounds tautological. :-)

Yeah you're right that would have been clearer.

Dave beat me to it and has already applied it, but thanks for reviewing
it anyway.

cheers
