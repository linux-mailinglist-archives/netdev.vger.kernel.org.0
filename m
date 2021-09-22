Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2EA414E9F
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhIVRDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:03:48 -0400
Received: from aposti.net ([89.234.176.197]:49826 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236836AbhIVRDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 13:03:45 -0400
Date:   Wed, 22 Sep 2021 18:01:58 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header
 files
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Cai Huoqing <caihuoqing@baidu.com>,
        Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        strace development discussions <strace-devel@lists.strace.io>,
        linux-api@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ldv@strace.io
Message-Id: <AZHUZQ.4E5G2GAEGJ0U@crapouillou.net>
In-Reply-To: <20210902160840.GA2220@asgard.redhat.com>
References: <20210813120803.101-1-caihuoqing@baidu.com>
        <20210901160244.GA5957@asgard.redhat.com>
        <20210901165202.GA4518@asgard.redhat.com> <1797920.tdWV9SEqCh@x2>
        <20210902133529.GA32500@LAPTOP-UKSR4ENP.internal.baidu.com>
        <20210902160840.GA2220@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>>  IPX is marked obsolete for serveral years. so remove it and the
>>  dependency in linux tree.
>>  I'm sorry to not thinking about linux-audit and strace.
>>  Might you remove the dependency or make the part of the code.
>>  Many thanks.
> 
> Unfortunately, that is not how UAPI works.  That change breaks 
> building
> of the existing code;  one cannot change already released versions
> of either audit, strace, or any other userspace program that happens
> to unconditionally include <linux/ipx.h> without any fallback (like
> <netipx/ipx.h> provided by glibc).

Also, the <netipx/ipx.h> fallback is only provided by glibc (and maybe 
uclibc?). With this patch, it is now impossible to compile even the 
very latest version of "strace" with a musl toolchain.

Cheers,
-Paul


