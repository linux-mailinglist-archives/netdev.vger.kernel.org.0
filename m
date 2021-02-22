Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716FC3215DC
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhBVMMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:12:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14181 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhBVMMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:12:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60339f670000>; Mon, 22 Feb 2021 04:11:19 -0800
Received: from [172.27.13.143] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 12:11:18 +0000
Subject: Re: [PATCH iproute2] dcb: Fix compilation warning about reallocarray
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210222120943.2035-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <9eafec1d-1b24-657a-b3d4-fc28972a9946@nvidia.com>
Date:   Mon, 22 Feb 2021 14:11:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222120943.2035-1-roid@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613995880; bh=li5nCXlQeOdo3X2/K80AwzDTzcFisFpnQYqxADAwX64=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=dhMi8Iu5JsyxiAwMdF/kzJriwtl+i2bzBZfeSsNg6u4msSBB5yhmDop20JchZFC/+
         fUrRRGo4A3hV5DJ6jbRMrWRULa4D8W8SSKhU5mSusOQ5n02kNadHcB6WuAg/nasZvw
         4hMLuE1Xyrqp6k2fDtV/w2vyH86HHXjiFByk0lo7tR7d3qEXz2ChsXoxNIcgu724UI
         w6x3RXzS+Vj4UHKlmQxcpXZ3sspMrKkb7w6PyGqnLue7lIK2WazzDz15nvlm8o2CIG
         VNyLUb5yYb5gFVuGG/L3fxMY9MqEObqSN3HaSLT+giQccf6jA0ke74XcmJPxQs9+Bq
         lKK01rYwm131Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-22 2:09 PM, Roi Dayan wrote:
> To use reallocarray we need to add bsd/stdlib.h.
>=20
> dcb_app.c: In function =E2=80=98dcb_app_table_push=E2=80=99:
> dcb_app.c:68:25: warning: implicit declaration of function =E2=80=98reall=
ocarray=E2=80=99; did you mean =E2=80=98realloc=E2=80=99?
>=20
> Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>   dcb/dcb.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index 6640deef5688..32896c4d5732 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -5,6 +5,7 @@
>   #include <linux/dcbnl.h>
>   #include <libmnl/libmnl.h>
>   #include <getopt.h>
> +#include <bsd/stdlib.h>
>  =20
>   #include "dcb.h"
>   #include "mnl_utils.h"
>=20

sorry for the resend. please ignore. sent v2 of the patch.
