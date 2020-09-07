Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2525F2EF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgIGGEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:04:43 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15638 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIGGEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 02:04:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f55cd6d0000>; Sun, 06 Sep 2020 23:04:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 06 Sep 2020 23:04:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 06 Sep 2020 23:04:43 -0700
Received: from [10.2.54.50] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 06:04:42 +0000
Subject: Re: [PATCH iproute2 net-next v2] iplink: add support for protodown
 reason
To:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>
References: <20200829034256.47225-1-roopa@cumulusnetworks.com>
 <bbb1ce0c-c5e5-bdfd-57e4-80e6ccf6d3b3@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <0245336f-9a11-6e72-b26d-e04ba9911d53@nvidia.com>
Date:   Sun, 6 Sep 2020 23:04:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bbb1ce0c-c5e5-bdfd-57e4-80e6ccf6d3b3@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599458669; bh=hfkmNTVgQhJGD0yaMfoWKaEtA6Tp4MF6renm/txPrnA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=Zd7HMb5TGcc+Ra7sZFRCNu9BG2E7kfK/s06+tZebXsODJsRo/Ugu+JFmd1rGtuYa9
         vmRWMNVmhFf9KrWLG5VMQS3yUREbf5j2dCSX3hl8ndPaRPEWM+wG/Kj9WMuaPihAx8
         sezwGZskP3qNIg9vwhg+SZY0cJUDQOdtQhbBjy0sEqeL7HxMYJ8Os6LMpdd01gtEiW
         grQXomvzKKGjvcoubES/6XmEuwgO1Hl4vzEZMJ9gFmeaxrNDQEevtgGW4bN3MmBoiC
         7P3kgpyDtfS/cEzzwrqrMm7XKaNJkaN8XTfSblTiuw/PO3vxp1LOuBvXCk5PSfHsrX
         ApsChNV0FWy0Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/1/20 6:54 PM, David Ahern wrote:
> On 8/28/20 9:42 PM, Roopa Prabhu wrote:
>> From: Roopa Prabhu <roopa@cumulusnetworks.com>
>>
>> This patch adds support for recently
>> added link IFLA_PROTO_DOWN_REASON attribute.
>> IFLA_PROTO_DOWN_REASON enumerates reasons
>> for the already existing IFLA_PROTO_DOWN link
>> attribute.
>>
>> $ cat /etc/iproute2/protodown_reasons.d/r.conf
>> 0 mlag
>> 1 evpn
>> 2 vrrp
>> 3 psecurity
>>
> none of these are standardized right? Or perhaps they are through FRR?
>
> Would be worth mentioning in the man page that the reasons are localized
> if so.
yes, ack, will post a patch for the man-page update.
