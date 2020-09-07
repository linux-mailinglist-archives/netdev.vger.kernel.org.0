Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AF525F2EC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgIGGDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:03:03 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15366 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIGGDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 02:03:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f55cd04000b>; Sun, 06 Sep 2020 23:02:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 06 Sep 2020 23:02:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 06 Sep 2020 23:02:58 -0700
Received: from [10.2.54.50] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 06:02:57 +0000
Subject: Re: [PATCH net] netdevice.h: fix proto_down_reason kernel-doc warning
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <7275c711-b313-b78c-bea5-e836f323b0ef@infradead.org>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <d7d07067-1ee0-ac88-ed9e-51f06c5bd6b9@nvidia.com>
Date:   Sun, 6 Sep 2020 23:02:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7275c711-b313-b78c-bea5-e836f323b0ef@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599458564; bh=WUBxOgmP7ieRqz1hrCNcwwLwckFgqoyj6ScYoKKiWlw=;
        h=X-PGP-Universal:Subject:To:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=jaGgkuKCdiZeNxCCwAb0u3bBtUNwjGLOFC9ID53BDhWIHISONh6ADw+8wBmp4T51q
         7ourBY56adOBL6dyE8zCyvCc+iHjGzUo9mlkJc0Ta9U7VQkUTKyKUmFly6+qfKJDea
         7C+Kz2j9nFhHPhPp1EyoyW3+EQjsqkjXnSIxpTbsvPbYE0bAeiO1tGPg9rsgDchH/q
         2kCog6tck61A5htTkV5sfNLtHYmBwI8u0kJxVzxHhtdKybnTfvNaWC4qXBUcIti0QK
         1090DnQmTqB0lCFxOsRQ41d/x4cDGNOLiOYW+C18EYB60Ly2tUgjAqhnpX7x/O7LWe
         MTM2eF9fqNgJw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/6/20 8:31 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix kernel-doc warning in <linux/netdevice.h>:
>
> ../include/linux/netdevice.h:2158: warning: Function parameter or member 'proto_down_reason' not described in 'net_device'
>
> Fixes: 829eb208e80d ("rtnetlink: add support for protodown reason")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---

Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Thanks Randy


