Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0704443565
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhKBSTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhKBSTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 14:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06FB6054E;
        Tue,  2 Nov 2021 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635876993;
        bh=cRPpy+UUxT1KisqJzQLafTXSbc0uoGmiscoNPVld6Zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nZsUZMYjbmtP5Bb3U4fF+rhRU6zFxU5pM4ugBQwThEnF+AbeOQcshrkSXX1AcOQv9
         MoAc6I1l+JJj5yBryhefK/IGPbkfSLYE84NCVCcdbPGKcwnX5XfwKsn6KXYri7wi7d
         p7tGh2BtgKfljbbu5+pGgEibipfcaay7qWm8w0bJwCUJSLd01izDJzH/Ohv5DgVSaI
         8BHovIerciR5Ak+nAQfdIQiYl+40PEbCi7TpIjFnnWn8SV0LE73slsTfN3MNqqtkhm
         AFjxi2yFKCEu3B+99d5QIrKua2bz1yRVBWe1kmFnlFlprwDfTMKWO+CEFqqJoYqM/P
         +B409+ZBNY0hg==
Date:   Tue, 2 Nov 2021 11:16:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCHv2 net 0/5] kselftests/net: add missed tests to Makefile
Message-ID: <20211102111628.27f2ced9@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211102013636.177411-1-liuhangbin@gmail.com>
References: <20211102013636.177411-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Nov 2021 09:36:31 +0800 Hangbin Liu wrote:
> When generating the selftest to another folder, some tests are missing
> as they are not added in Makefile. e.g.
> 
>   make -C tools/testing/selftests/ install \
>       TARGETS="net" INSTALL_PATH=/tmp/kselftests
> 
> These pathset add them separately to make the Fixes tags less. It would
> also make the stable tree or downstream backport easier.
> 
> If you think there is no need to add the Fixes tag for this minor issue.
> I can repost a new patch and merge all the fixes together.

Thanks! Could you rebase on latest net/master and resend? 
We just forwarded the net tree for the next merge window.
