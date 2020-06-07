Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605EC1F0A4D
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 08:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgFGG4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 02:56:01 -0400
Received: from m12-16.163.com ([220.181.12.16]:39553 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgFGG4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 02:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=UlSCv
        JGb20Iir5IHscJG+4tQo9hliZ3Ic/DMrTbtMX4=; b=iQrU6mfQJpLRuR1mWSbvr
        YO80x50jlwSo2bav/eGk1OKRpiEFo+1O5PcuCh38ZGn2qJ0zdbBhCnmrpOvjPuFN
        errUHPqFpNmb+cHbI4JxfGgKCx7lADKnS9EueoFHr3cgiN6vuFeZ/DBkq6F9RRSU
        hZzxHjSfujohMhvaHBVxjg=
Received: from [192.168.0.3] (unknown [125.82.15.164])
        by smtp12 (Coremail) with SMTP id EMCowACXmQVmj9xeqp+iHA--.6551S2;
        Sun, 07 Jun 2020 14:55:37 +0800 (CST)
Subject: Re: [PATCH] net/mlx5: Add a missing macro undefinition
To:     Leon Romanovsky <leon@kernel.org>
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200607051241.5375-1-xianfengting221@163.com>
 <20200607063635.GD164174@unreal>
From:   Hu Haowen <xianfengting221@163.com>
Message-ID: <c96f7991-3858-4351-9804-4482e7689cd7@163.com>
Date:   Sun, 7 Jun 2020 14:55:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200607063635.GD164174@unreal>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: EMCowACXmQVmj9xeqp+iHA--.6551S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF47Jr18WFW3WFy3tF1UWrg_yoWfuFX_uw
        1xZwn7Za1DWF4FvF4xGFW5uFyUGrWUGr4rWr1Yq395Cw1Yya9rCw1kuryfZF15ZrWYyFnr
        C3Z0vFy5Z347ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5Vq2tUUUUU==
X-Originating-IP: [125.82.15.164]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/xtbBDwE8AFPAMKM3EAAAsV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/7 2:36 PM, Leon Romanovsky wrote:
> On Sun, Jun 07, 2020 at 01:12:40PM +0800, Hu Haowen wrote:
>> The macro ODP_CAP_SET_MAX is only used in function handle_hca_cap_odp()
>> in file main.c, so it should be undefined when there are no more uses
>> of it.
>>
>> Signed-off-by: Hu Haowen <xianfengting221@163.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
>>   1 file changed, 2 insertions(+)
> "should be undefined" is s little bit over statement, but overall
> the patch is good.


Sorry for my strong tone, but my idea is that every macro which is
defined and used just in a single function, is supposed to be undefined
at the end of its final use, so that you won't get into trouble next
time if you define a macro with the same name as this one.


>
> Fixes: fca22e7e595f ("net/mlx5: ODP support for XRC transport is not enabled by default in FW")
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

