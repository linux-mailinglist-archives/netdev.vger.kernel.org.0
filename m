Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9D0148C54
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389003AbgAXQhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:37:55 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:44134 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387687AbgAXQhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:37:55 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4EE530006E;
        Fri, 24 Jan 2020 16:37:49 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 24 Jan
 2020 16:37:46 +0000
Subject: Re: [PATCH v2 net-next 0/3] sfc: refactor mcdi filtering code
To:     "Alex Maftei (amaftei)" <amaftei@solarflare.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <095b9db9-4bdf-cf01-7d3a-94acb9eaa494@solarflare.com>
Date:   Fri, 24 Jan 2020 16:37:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25186.003
X-TM-AS-Result: No-9.141700-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9oPPOu2yMJlMda1Vk3RqxOGUs
        fNazqaz0f1xSt/ApHHOQ5EOn6ZDjFeeiDxJcK5MJuZBZOg7RfX9ZbM2hfH4YXrEJXf7wJ5WFBzW
        QqFQdsUiLrhTfkxEO5Baynp4lvsDbofaD2zI+zzzwqDryy7bDITDoUQeQv/CPmyiLZetSf8nJ4y
        0wP1A6AESNmwM0HlDFjaPj0W1qn0TGVuWouVipcjP05R40HU5axeOLeSrYaaOrpACW0+ATj7RNV
        qs2Jza4htmVfJnYnBbJNR995LyDy8ln7BH1nvJgDWgPwEWqGjv8/EYLL7FME4VyAlz5A0zC7xsm
        i8libwVi6nHReNJA8sM4VWYqoYnham2pp47lr+A=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.141700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25186.003
X-MDID: 1579883870-X6BtCw9SXkzw
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/01/2020 16:33, Alex Maftei (amaftei) wrote:
> Splitting final bits of the driver code into different files, which
> will later be used in another driver for a new product.
> 
> This is a continuation to my previous patch series. (three of them)
> Refactoring will be concluded with this series, for now.
> 
> As instructed, split the renaming and moving into different patches.
> Minor refactoring was done with the renaming, as explained in the
> patch.
> 
> Alexandru-Mihai Maftei (3):
>   sfc: rename mcdi filtering functions/structs
>   sfc: create header for mcdi filtering code
>   sfc: move mcdi filtering code

For the series:
Reviewed-by: Martin Habets <mhabets@solarflare.com>

>  drivers/net/ethernet/sfc/Makefile       |    2 +-
>  drivers/net/ethernet/sfc/ef10.c         | 2476 +----------------------
>  drivers/net/ethernet/sfc/mcdi_filters.c | 2270 +++++++++++++++++++++
>  drivers/net/ethernet/sfc/mcdi_filters.h |  159 ++
>  4 files changed, 2505 insertions(+), 2402 deletions(-)
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_filters.c
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_filters.h
> 
