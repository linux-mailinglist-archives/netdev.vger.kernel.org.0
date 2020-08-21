Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D63324CD2E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 07:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgHUFSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 01:18:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7709 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgHUFSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 01:18:31 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3f59190000>; Thu, 20 Aug 2020 22:18:17 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 22:18:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 20 Aug 2020 22:18:30 -0700
Received: from [10.2.62.5] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Aug
 2020 05:18:30 +0000
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     <dsahern@gmail.com>, <netdev@vger.kernel.org>
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
 <20200820213649.7cd6aa3f@hermes.lan>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <1ad9fc74-db30-fee7-53c8-d1c208b8f9ec@nvidia.com>
Date:   Thu, 20 Aug 2020 22:18:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820213649.7cd6aa3f@hermes.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597987097; bh=PGuO7ZyK5Ya4r+BCjLwAMikRLP8/Xs84gWNmVK8+vKY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=dUdaV8adnzP8REA73oABsNZoWnUEP5sxuKBaAq6z2dN/u7nHgnUB75tlVzhCuX0aB
         6iCkbzhvFwAAKCxSWebd4aJKO/cTG4NlNXxdBFu8T7jd+Lgb+tNGp7TdJ4YWMoPd6B
         ji/0Ktg6hjpqpY1Q7wltxeUavLfzFbmJK2hMFIBM84+sLkjFW2gTYeF7mz7l9TyGwA
         9v0RSXy/oc2WYpkHz1uYiy7yXUqj84vMPlkd0fWcDAweZHYJ/UpGgU5EhGbv9/JgJC
         +T8aQTgPm/El7vZj5OaESTNNBXckhRWfWq4mSaiLI0M0tP9Li+/K/9qmhRiFEalKTr
         YgDkuzyFpCTBw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/20/20 9:36 PM, Stephen Hemminger wrote:
>
>
> On Thu, 20 Aug 2020 20:52:02 -0700
> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
>> +     if (tb[IFLA_PROTO_DOWN]) {
>> +             if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
>> +                     print_bool(PRINT_ANY,
>> +                                "proto_down", " protodown on ", true);
> In general my preference is to use print_null() for presence flags.
> Otherwise you have to handle the false case in JSON as a special case.


ok, i will look. But this is existing code moved into a new function and 
has been

working fine for years.


