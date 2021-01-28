Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFD1306B20
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhA1CfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:35:16 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2986 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhA1CfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:35:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601222bb0001>; Wed, 27 Jan 2021 18:34:35 -0800
Received: from [172.27.8.81] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 02:34:34 +0000
Subject: Re: [PATCH net-next] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>
References: <20210126145929.7404-1-cmi@nvidia.com>
 <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0837f7ce-cdb9-fe3e-ac10-acfc3e35ee30@nvidia.com>
 <66cb9c747a98e911d71187332683e1bb548a6c44.camel@kernel.org>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <8fca0e1c-1318-2a63-5d21-0d8116d593ba@nvidia.com>
Date:   Thu, 28 Jan 2021 10:34:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <66cb9c747a98e911d71187332683e1bb548a6c44.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611801275; bh=a+3v4d1ekVxxSeYZT4pgF3ZT0DxRVTATyLEmgSKtjEQ=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=J0mOLe8wlGEuLxGD7s18dd0hTAfUz7U6Wt4ldN5J2+VdIVP8w7ez/xrfVBakYI8FH
         g/C1t03HczH2SiCa/nGTTIOwNo22EWDNnDpGrspXqw0E/EQp8sORFb0T98WeReEhqS
         9vj46FTE8E/kK2W29ikDuZsx8a1RisOcIrw/rSs4KmPm7sTBE4E6kymMdtnG8EhbSk
         +judgUKH0KqLE10e37asfS+KEXgFGLxB15yJEtQwjyK8UhBcgTTG6bpxB3da/3iF7b
         2nLCI76TZG7JzEwXazLDvvTAd0D420/O0ZFasLZsCVL1rJGJy/VevwRnM4i5n8/27p
         ncBNL/8E8tHkA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/2021 7:03 AM, Saeed Mahameed wrote:
> On Wed, 2021-01-27 at 11:42 +0800, Chris Mi wrote:
>
>> Could you please tell me what's sparse warnings you hit?
> https://patchwork.kernel.org/project/netdevbpf/patch/20210127101648.513562-1-cmi@nvidia.com/
>
> build allmodconfig and build32
OK, I see. Thanks, Saeed.
