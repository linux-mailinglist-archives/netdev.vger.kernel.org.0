Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446B8240AB3
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgHJPoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:44:30 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:54910 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgHJPo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:44:29 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07AFhw58086078;
        Mon, 10 Aug 2020 10:43:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597074238;
        bh=WkEloO0vK6rOToy94HdrGPp6kcZXQrZulDOI3ozBGjM=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=PtZVxNAQS7tKESdGPbarT6BJ5ycfc83vXrzaWBsBUdO/7iewL22Wc/pcXl0GnEBlO
         7HKhaDnbgTyhNCS2NpY3+bGNHkNwHqTjqKRjmWlcMzWkO4lbFI6ia1i0I2tOrTif+e
         lxsGVAd4Zk4KrL8/tmleZb46SqDgnXz1bNWuqplI=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07AFhwu0038934;
        Mon, 10 Aug 2020 10:43:58 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 10
 Aug 2020 10:43:58 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 10 Aug 2020 10:43:58 -0500
Received: from [10.250.227.175] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07AFhuQg012659;
        Mon, 10 Aug 2020 10:43:56 -0500
Subject: Re: [net-next iproute2 PATCH v4 0/2] iplink: hsr: add support for
 creating PRP device
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <kuznet@ms2.inr.ac.ru>
References: <20200806203712.2712-1-m-karicheri2@ti.com>
Message-ID: <8be17fb1-7ffc-aab4-aec2-b3b4bacf26d8@ti.com>
Date:   Mon, 10 Aug 2020 11:43:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806203712.2712-1-m-karicheri2@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute2 maintainers,

On 8/6/20 4:37 PM, Murali Karicheri wrote:
> This series enhances the iproute2 iplink module to add support
> for creating PRP device similar to HSR. The kernel part of this
> is already merged to net-next and the same can be referenced
> at https://www.spinics.net/lists/linux-api/msg42615.html
> 
> v3 of the series is rebased to iproute2-next/master at
> git://git.kernel.org/pub/scm/network/iproute2/iproute2-next
> and send as v4.
> 
> Please apply this if looks good.
> 
> Murali Karicheri (2):
>    iplink: hsr: add support for creating PRP device similar to HSR
>    ip: iplink: prp: update man page for new parameter
> 
>   ip/iplink_hsr.c       | 19 +++++++++++++++++--
>   man/man8/ip-link.8.in |  9 ++++++++-
>   2 files changed, 25 insertions(+), 3 deletions(-)
> 
Please merge this series to iproute2 as it is the missing piece
needed to fully support PRP protocol support in netdev subsystem. Kernel
part is already merged and expected to be in v5.9.x kernel.

Thanks
-- 
Murali Karicheri
Texas Instruments
