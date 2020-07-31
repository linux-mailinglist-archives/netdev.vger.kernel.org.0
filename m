Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75D6233D8A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 04:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731280AbgGaC7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 22:59:08 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6724 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731262AbgGaC7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 22:59:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2388ee0000>; Thu, 30 Jul 2020 19:58:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 30 Jul 2020 19:59:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 30 Jul 2020 19:59:07 -0700
Received: from [10.2.59.182] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 31 Jul
 2020 02:59:06 +0000
Subject: Re: [PATCH net-next] rtnetlink: add support for protodown reason
To:     David Miller <davem@davemloft.net>, <roopa@cumulusnetworks.com>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <nikolay@cumulusnetworks.com>
References: <1595877677-45849-1-git-send-email-roopa@cumulusnetworks.com>
 <20200730.163820.505646845935151146.davem@davemloft.net>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <344b71b6-82f8-bc7a-235b-6b372415084a@nvidia.com>
Date:   Thu, 30 Jul 2020 19:59:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730.163820.505646845935151146.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596164334; bh=qRpfWkkTuNznGkulpcgf5KeQvHBgGQtqy7IgjsyWOl4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=k5z2BdMkprDEZJdm3QedYoeqf4/UL0n5Vta0gzBdGVWr4S7ByspVpVU/FdWQ3rUFi
         3HBY5y5xZF1+B6a5/8ZBkd/EGKqye50MGg5EkuTK8ZSqBZIp9/Vd85SOQqpQzYvncN
         IlkfwudeJFIxFYuFvHfJRrvZIECxAShP33EiXT+ov5RURnrqG9LTkDWGgGM/axSaCN
         t6JzL/w725Zit0KmSSJT+5ChFYWhMfqvRM2avXZcNtV18JKPl3TRozBQb+zXMLvI9g
         W59nrA9OaOQ3fjrKlm2e+xWjU3BdbcEV4Ekt6v0fhkqkqU4oUOqQOQGp74jiW50g+z
         glYfHnb71nCkg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/30/20 4:38 PM, David Miller wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> Date: Mon, 27 Jul 2020 12:21:17 -0700
>
>> +/**
>> + *   dev_get_proto_down_reason - returns protodown reason
>> + *
>> + *   @dev: device
>> + */
>> +u32 dev_get_proto_down_reason(const struct net_device *dev)
>> +{
>> +     return dev->proto_down_reason;
>> +}
>> +EXPORT_SYMBOL(dev_get_proto_down_reason);
> This helper is excessive, please remove it and just dereference the
> netdev member directly.
>
> Thank you.


agree, will send v2. (it was meant to do more than just that initially)


