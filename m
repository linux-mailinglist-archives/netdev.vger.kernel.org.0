Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC4F286A07
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgJGV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:26:01 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7969 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgJGV0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:26:00 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7e325c0000>; Wed, 07 Oct 2020 14:25:48 -0700
Received: from [10.25.78.23] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 21:25:56 +0000
Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
To:     David Miller <davem@davemloft.net>
CC:     <saeed@kernel.org>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <erezsh@nvidia.com>, <mbloch@nvidia.com>, <saeedm@nvidia.com>
References: <20200928.144149.790487567012040407.davem@davemloft.net>
 <d53133e1-ca35-40cd-3856-f8592fd4895e@nvidia.com>
 <c231b69d-812a-b98e-b785-a807d6d640b5@nvidia.com>
 <20201006.074715.742357947812105732.davem@davemloft.net>
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
Message-ID: <46d7768f-033b-c61f-f2a8-c38239b9d547@nvidia.com>
Date:   Thu, 8 Oct 2020 00:25:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006.074715.742357947812105732.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602105948; bh=sZvMH9LdrRcfe5RvGb09sBCcHPkZfkyWS8wDFe2a6U4=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=hL+84d7CIvdxp3aPK8r97vp4ikgZeIPQuRP1eQgs/gqDXvKr9DJpL7Dj0WfwHk8i4
         0KUhS19B/5jymH92Ta+fiCDAFAWrXE/pIaEkeiJLLEVXX6Z5YoxYioVLP06QuvbP70
         CVh6Hd4dVDQERzTO6hb1aGQjoKdfsL2Ee5h7Cv90Hliw674gK98qY03AP3+eVJP+sj
         5WgYvLT2IacGQHjyZvd5u6bbMbwdEDjdixT7xNN+S5qHQEKsh4Vkv7ZBusX9zknnhD
         R4x4NSovfcp0mIH15C1ipRB3XwS2xTETZEKo2VEDotyTiZdwPn2CNTl6hpw0zjVajS
         CnatGPbrF8Zxg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06-Oct-20 17:47, David Miller wrote:
 > From: Yevgeny Kliteynik <kliteyn@nvidia.com>
 > Date: Tue, 6 Oct 2020 16:02:24 +0300
 >
 >> Buddy allocator allocates blocks of different sizes, so when it
 >> scans the bits array, the allocator looks for free *area* of at
 >> least the required size.
 >> Can't store this info in a 'lowest set bit' counter.
 >
 > If you make it per-order, why not?

OK, I=E2=80=99ll send the V2 series with the standard allocator.
The optimization will be handled in a separate patch later on.

Thanks

