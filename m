Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD383052B5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhA0GCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:02:01 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18074 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbhA0Dm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:42:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010e1190000>; Tue, 26 Jan 2021 19:42:17 -0800
Received: from [172.27.8.81] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 03:42:16 +0000
Subject: Re: [PATCH net-next] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <saeedm@nvidia.com>
References: <20210126145929.7404-1-cmi@nvidia.com>
 <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <0837f7ce-cdb9-fe3e-ac10-acfc3e35ee30@nvidia.com>
Date:   Wed, 27 Jan 2021 11:42:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611718937; bh=t/FJwhwz9UbCSKdWW9Yey0a0hNYMPKvTHdbjVh8tJ14=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=FYx2N/K4fgaKgwyvlI2GYZJ64GyZCwv70dzdoT6wx4xigojQfhBU03Ka+GghfsPef
         szDoatbzNUo4bzTIDCjiRgFatthXk3b3XBtsVFUrN/rvJRADWjKCo/Nd60WKuQ45d0
         cC3YPxU1wK1XREt0QsGDoeoVD3/T73sBOgHa4/h13YAOg9uo99XDkll4XKvdSKD1RB
         NsgSBOLxHTgI8tSnvbeaKGBIznaCIxEDa/CPZAecquwUaUy+ipV2rgRX3CmelafsHF
         zps7qDlMeGqJNNrc1xtwu5+R5/p7cE8h4x6naZA1Cc+KpBBW6ThOBZ3Mwgnwy0XrbL
         sRUzFxB9eCN5Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 1/27/2021 10:49 AM, Jakub Kicinski wrote:
> On Tue, 26 Jan 2021 22:59:29 +0800 Chris Mi wrote:
>> In order to send sampled packets to userspace, NIC driver calls
>> psample api directly. But it creates a hard dependency on module
>> psample. Introduce psample_ops to remove the hard dependency.
>> It is initialized when psample module is loaded and set to NULL
>> when the module is unloaded.
>>
>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> This adds a bunch of sparse warnings.
>
> MelVidia has some patch checking infra, right? Any reason this was not
> run through it?
Could you please tell me what's sparse warnings you hit?
Just now I ran ./scripts/checkpatch.pl again without "--ignore 
FILE_PATH_CHANGES",
I got the following warning:

WARNING:FILE_PATH_CHANGES: added, moved or deleted file(s), does 
MAINTAINERS need updating?
#128:
new file mode 100644

I'll change it. But I'm not sure if this is the only thing I need to change.
So could you please elaborate? I'll pay attention to it in the future.

Thanks,
Chris
