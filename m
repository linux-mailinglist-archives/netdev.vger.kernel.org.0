Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530232C9240
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgK3XLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:11:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1510 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgK3XLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:11:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc57beb0001>; Mon, 30 Nov 2020 15:10:35 -0800
Received: from yaviefel (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Nov 2020 23:10:22
 +0000
References: <20201130002135.6537-1-stephen@networkplumber.org> <20201130002135.6537-4-stephen@networkplumber.org>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <petrm@mellanox.com>
Subject: Re: [PATCH 3/5] tc: fix compiler warnings in ip6 pedit
In-Reply-To: <20201130002135.6537-4-stephen@networkplumber.org>
Date:   Tue, 1 Dec 2020 00:10:18 +0100
Message-ID: <87zh2yo2zp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606777835; bh=C1ARq0Kc8+nQRA4M73PmoasHNbk37hEIWyookRRuyzw=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=M3FT+7CfM+0AxYIye25ohHPMrxoyGIbg3hfo95Hq7Bc+pDXk+WCPqGlxGfpBWoVRK
         /MF3pFvPa5oZYNidcW36fsg1cCLHQHnK3XHcKJTjChz2QygmOBjfDDZZv3DztorTDC
         gkA55tZyij9mzGx6c7oZoe/uYvaS2bJ5vvArxpjet1sVdAR9ucvjfZoYzf9M6/XiUM
         o1gP3laEd4K3WYKAsBu+JoIS3zsss1KYcORiALoeM+mYth+IV8IJYjWCefM0TSuxKB
         F8pLxkDe7EfKnYtDUkonQpdle8V9jiuGsho+CA9vRRSneDtSnk5N1667G2zAu2OJzs
         CtqUZTKHU22Fw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> Gcc-10 complains about referencing a zero size array.
> This occurs because the array of keys is actually in the following
> structure which is part of the overall selector.
>
> The original code was safe, but better to just use the key
> array directly.
>
> Fixes: 2d9a8dc439ee ("tc: p_ip6: Support pedit of IPv6 dsfield")
> Cc: petrm@mellanox.com
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Reviewed-by: Petr Machata <petrm@nvidia.com>
