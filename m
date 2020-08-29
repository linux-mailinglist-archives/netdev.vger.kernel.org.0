Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06B325648C
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 05:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgH2Dlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 23:41:45 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2824 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH2Dlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 23:41:44 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f49ce4c0000>; Fri, 28 Aug 2020 20:41:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 20:41:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 28 Aug 2020 20:41:43 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 29 Aug
 2020 03:41:43 +0000
Received: from [10.2.63.130] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 29 Aug
 2020 03:41:43 +0000
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
To:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
 <f9a02516-f954-2b97-ed12-8fbad2f2271a@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <29ff0728-1ef3-4c59-ad76-d6648cafe465@nvidia.com>
Date:   Fri, 28 Aug 2020 20:41:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f9a02516-f954-2b97-ed12-8fbad2f2271a@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598672460; bh=a8OE3RbXcAYnxdgopxkplo1X0/LuLFi0G+m/SwJyncA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=qFJWwwrrKqgTYSw9T6lSio4Vny9SD6ngE7CCyGExdsHMt68pUCh2C8z8u54lSbkxp
         eu+5cfgvgqDkOxxhYJvfKmuUZkWwS4+q90afgvdXncyN3AiCRTS3QwQBuxwwcNfJEK
         61mW+t2/kUXCF696Sgpm+D7NfwX5TxpVhXKolddMXeiyl2Q1xnsUnl7PyOHmwgzZcF
         gi4FnUWCNM8JnXno3wXZIcE3dPTadxe3t+3VTB+jSccdIhAqV0MuTygpVxMAEkQcDl
         6zh/BSjG8JLRzAKd5LnEKK0kIbAhI1yWxlKP7rIW85J7Z+SHlatxKerJj4W412tkdv
         j5wJQ+ArNfRlg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/23/20 7:20 PM, David Ahern wrote:
> External email: Use caution opening links or attachments
>
>
> On 8/20/20 9:52 PM, Roopa Prabhu wrote:
>> +void protodown_reason_n2a(int id, char *buf, int len)
>> +{
>> +     if (id < 0 || id >= PROTODOWN_REASON_NUM_BITS || numeric) {
> since the reason is limited to 0-31, id > PROTODOWN_REASON_NUM_BITS
> should be an error.


copy paste from other functions in rt_names which do the same thing.

v2 coming with fix for this and other comments. thanks for the review.


