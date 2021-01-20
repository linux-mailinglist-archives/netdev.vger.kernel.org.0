Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D762FCF08
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbhATLRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:17:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4968 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbhATKrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:47:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60080a050002>; Wed, 20 Jan 2021 02:46:29 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan 2021 10:46:26
 +0000
References: <cover.1610978306.git.petrm@nvidia.org>
 <151e504b32f5005652c64cdde5186ef8f96303e5.1610978306.git.petrm@nvidia.org>
 <20210119125552.4815bc6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] nexthop: Use a dedicated policy for
 nh_valid_dump_req()
In-Reply-To: <20210119125552.4815bc6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 20 Jan 2021 11:46:23 +0100
Message-ID: <87im7r6g3k.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611139589; bh=PixjbG+q4zq+2f9LtbfhDIbd6tX3hw5Manw0BK0eeS4=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=EIWwzjZZKCLH0SRsWIaaAIv4mjLSDcU4clatTGrpA6QYAiHNn66RYWhhlVuP625SN
         jJP6A4r1V4YZMyS9QHSqZ5FqBc8lQL0J0WsFQEwsalxopTlZUqeiCWAmjn7EXxYpdg
         ag1hjUj7WwCmr2hbG//gJ6DLCXnBCErkG55rMhrQZ8Z5tjzNCAAclg53kDcrDBZ8tB
         e8+O66/mXwieV19SYrJXAr5KKRJzKHUWRsVRKEG4Yq52yvqZeYolpexrFfQlwjBWBr
         sfDQnzIUGREf4rKyX4YcrNC1YcQiXn8Q5EgmZBLJDQssVLTdhd0L/F7OFtwIOggtpP
         uehzzODZmB3MA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 18 Jan 2021 15:05:24 +0100 Petr Machata wrote:
>> +	if (tb[NHA_GROUPS])
>> +		*group_filter = true;
>> +	if (tb[NHA_FDB])
>> +		*fdb_filter = true;
>
> nla_get_flag()

OK.
