Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83794308582
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhA2GJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:09:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13727 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhA2GJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:09:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6013a66e0000>; Thu, 28 Jan 2021 22:08:46 -0800
Received: from [172.27.8.81] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 06:08:43 +0000
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
Date:   Fri, 29 Jan 2021 14:08:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611900526; bh=Vc4gJttJI+xtzioHQwS4i4S3Z/5IHtromg9AC4JYA4w=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=Xtu/gt7BJ6exW/HsOMcb/j1c9Y3+LxZoY7wro1oZ/A/mbqtynEzF+uTrM8w6w8bZT
         1jxVgeevUA2ULMCjBvxNdTUzNgM0wJDg0BuSSMbL6xFwij7bVnccq0vK5oydRGI73O
         CHWOYpQCa9ATvkGOn18EDmw2qjLnA+QOPkM7Xf+SNRS7HelYOQn+yIgdwpFY+S23Uf
         mcQtm7NToJYnvDqvPJ1YG9UTAZqAx/WyNZnETTyp0KvcOz+iSJrFC1q3rbYRRVAvO2
         l/wpBEKbsp3UZB1G+P0fIxtaHg4JIGiPSGIPmvhBBu9V5R4FHFjPXRSDDD1UixHQir
         BpE97MvDpmEiQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/2021 1:14 PM, Cong Wang wrote:
> On Wed, Jan 27, 2021 at 5:48 PM Chris Mi <cmi@nvidia.com> wrote:
>> In order to send sampled packets to userspace, NIC driver calls
>> psample api directly. But it creates a hard dependency on module
>> psample. Introduce psample_ops to remove the hard dependency.
>> It is initialized when psample module is loaded and set to NULL
>> when the module is unloaded.
> Is it too crazy to just make CONFIG_PSAMPLE a bool so that it
> won't be a module?
>
> Thanks.
That's a crazy and simple solution. But adding such a stub is a common 
method to
remove the NIC driver dependency for modules. And comparing with other 
act_xxx
modules, psample is not small now.

Instead of discussing it several days, maybe it's better to review 
current patch, so that
we can move forward :)

Thanks.
