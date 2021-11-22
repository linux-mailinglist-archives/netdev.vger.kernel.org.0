Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C8F4590E9
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbhKVPKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:10:19 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:59525 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhKVPKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:10:18 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MKsaz-1n5TwB3cmj-00LBBC; Mon, 22 Nov 2021 16:07:10 +0100
Received: by mail-wr1-f48.google.com with SMTP id d27so33337930wrb.6;
        Mon, 22 Nov 2021 07:07:10 -0800 (PST)
X-Gm-Message-State: AOAM533LV0nFU+UuQDxfJ/BdogCdHvTboTJp58aFy4Z8UVvi7MLJwv0E
        aeRtDVldFglU4gDp4/OhqX1SIIeRjihydYI7Uec=
X-Google-Smtp-Source: ABdhPJwxmbi12skGLI3gqc0ou3jouz1nDZqczVP9I5k3W/RPkUTxwoF1ZyEX3BlxvuO+y6Yya0iVasXMO++ffBKYDKs=
X-Received: by 2002:adf:f7c2:: with SMTP id a2mr39737082wrq.71.1637593630460;
 Mon, 22 Nov 2021 07:07:10 -0800 (PST)
MIME-Version: 1.0
References: <20211122150322.4043037-1-arnd@kernel.org>
In-Reply-To: <20211122150322.4043037-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 22 Nov 2021 16:06:54 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3g3193asu3N=j4g8iihYfFRqj54HnLdxbiJsQ2gn088g@mail.gmail.com>
Message-ID: <CAK8P3a3g3193asu3N=j4g8iihYfFRqj54HnLdxbiJsQ2gn088g@mail.gmail.com>
Subject: Re: [PATCH] nixge: fix mac address error handling again
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Moritz Fischer <mdf@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:T2NzkPSW1ejmrkbp3CFzUwm1AmnailcgPSmL6siQkN/gSGCM/y1
 DFLJ4o2xrpiWW+Mh7ocktloAtIpNiJfGrtJADA10eEZbySiAkIRdVE5lQTkLkhdN4TpoVWR
 BJll+dVynFRTIKWQvQEjzgFvf9wG20Cm4YZ/c/8jjiSbrKazQ9qKcVAB77ic5dXy2nLLa3l
 E2NmUISnB3CYp0WfOLdLw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4IALklRBB0Q=:OvbBsGFaCgqCOqT8/gdmgZ
 cyB9NRalCZzs0u+8ljjFnmtSxg6FO/EoYPVSVucVX1Op8t6/ulHl79nSAblLI+ycbFTAIXQKK
 wRB0nHvrJ1I9U+Vy/1az3qwgK8kVxwB82ocAguhW6mxjGR6LwzviEEpbtEco1pRDvMel3PPI9
 4G+a6iDTfkWosrK4TYV9i4OiCDfjc4y3NHOsYwg4nL/YKyQrjdSlyS6KywznbplPPivJH3RY5
 ZquSEUIgLLuVy2h/7TFS2NYxQtI0Z59g5TXuAOeB6PiCsowip8b03OTQJElke17e/EX7tdmFm
 LVPO7zWPjnPsIQ0K8L4hwofO0eZqSFuvE49rB9rzJWpQwhR6+4xufgyAymHNfZpCjJyfksSzr
 M9jBE2fS/lsdEIVA501tnjJHt5q0ppHzFTgs6OfLOzkJLtF4BONJMCl4X2BWG977Jq4IqqXtg
 7fKi8NCY3yBDF6stDk82ajEOwcbYXYLyclDRQ4S4+7fNILrZNSkYJuWpsqKyzmiV0Usdz7oFJ
 A9H53x162ElP6oPMWXsDjDsnxrPw4MUds2s/iPa1RrUcKI4GufB0LetzBF5L1sMkgMQYiay1Y
 CgGxKsQNZBWrdxWopVA5Ic6qRwRG9aDXksRkMeY72dFvugxmasbeex7ilQ0QGpMgJcRXrBSWP
 MU57LYR+j8pMOYjprJsRL8fKuUMd+I0evpku14z/epb03Oe4yx1StM6ljUWrToUGoMlgzTFXO
 Y/uoVcPrqW1Jg+WtAh28zQFSCvKAcVLtV5iyQECuMyh1O7krnAKIhH7Pk+X7g5kCULQbFvv3i
 btWFzqou1bp6g4u3/PgZOUJn8X5LYbfDTULfk23r5/yUdU5Iy0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 4:02 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The change to eth_hw_addr_set() caused gcc to correctly spot a
> bug that was introduced in an earlier incorrect fix:
>
> In file included from include/linux/etherdevice.h:21,
>                  from drivers/net/ethernet/ni/nixge.c:7:
> In function '__dev_addr_set',
>     inlined from 'eth_hw_addr_set' at include/linux/etherdevice.h:319:2,
>     inlined from 'nixge_probe' at drivers/net/ethernet/ni/nixge.c:1286:3:
> include/linux/netdevice.h:4648:9: error: 'memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]
>  4648 |         memcpy(dev->dev_addr, addr, len);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> As nixge_get_nvmem_address() can return either NULL or an error
> pointer, the NULL check is wrong, and we can end up reading from
> ERR_PTR(-EOPNOTSUPP), which gcc knows to contain zero readable
> bytes.
>
> Make the function always return an error pointer again but fix
> the check to match that.
>
> Fixes: f3956ebb3bf0 ("ethernet: use eth_hw_addr_set() instead of ether_addr_copy()")
> Fixes: abcd3d6fc640 ("net: nixge: Fix error path for obtaining mac address")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Sorry, I sent out the wrong patch, this version fixes the bug but not the
warning. v2 is the version I actually tested successfully.

       Arnd
