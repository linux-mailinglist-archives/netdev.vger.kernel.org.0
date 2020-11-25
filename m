Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7730C2C3E4A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 11:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgKYKmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 05:42:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3412 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgKYKmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 05:42:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe35080000>; Wed, 25 Nov 2020 02:42:16 -0800
Received: from [10.26.75.210] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 10:41:58 +0000
Subject: Re: [PATCH net-next v2 1/2] ethtool: Add CMIS 4.0 module type to UAPI
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <1606123198-6230-2-git-send-email-moshe@mellanox.com>
 <20201123144011.0000713e@intel.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <2c1a8e9f-55b2-b258-2b72-2d76db27550a@nvidia.com>
Date:   Wed, 25 Nov 2020 12:41:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201123144011.0000713e@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606300936; bh=9H/XZW7V+Tl44nzigrlzp9NPlvGb0hA0OceVc5zfl0k=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=FfnIQw16Uwo7ttXx+v7Wo23qKOVJ04Exy9i0b+S6Kj33PaRJmLiN91fVOotFhTbe0
         dXrcbGs4sYCHqh/4lk1sbm9veW+mjQ4hgC/g2rXpr9BBJi4KOsV3MGKOaJ29PCfSny
         kSoPZkMLpwlaRqOl1l+NCvbzpgnYevvT95+wIvPhaaqGTJcnZ/UShZRuVoInxD5+mY
         ZSqpkDqkm64SA8gtM7bmwoFmvAVPV9i2Je3lBUNgCOWpCysyqo8Pfov0hLdFNdVhbb
         bQzxR0pT6EghXsoQ58Spg9Kup0SCm3BIIt7RFOSKlhcKPTQTLoUqiUPL/nvxuApRgh
         EM0qBY1qq7xCQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/24/2020 12:40 AM, Jesse Brandeburg wrote:
> External email: Use caution opening links or attachments
>
>
> Moshe Shemesh wrote:
>
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> CMIS 4.0 document describes a universal EEPROM memory layout, which is
>> used for some modules such as DSFP, OSFP and QSFP-DD modules. In order
>> to distinguish them in userspace from existing standards, add
>> corresponding values.
>>
>> CMIS 4.0 EERPOM memory includes mandatory and optional pages, the max
> typo? s/EERPOM/EEPROM
Right, thanks.
>
>> read length 768B includes passive and active cables mandatory pages.
>>
>> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> rest was ok.
