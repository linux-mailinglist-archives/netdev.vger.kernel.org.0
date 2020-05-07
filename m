Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5339D1C860C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 11:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgEGJrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 05:47:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39760 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEGJrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 05:47:00 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200507094658euoutp0161d18747e20d120a9b02630065e2e065~MtfHBK2ij3240732407euoutp019
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:46:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200507094658euoutp0161d18747e20d120a9b02630065e2e065~MtfHBK2ij3240732407euoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588844818;
        bh=1wsC40WzFUpfzSznWf2jwxe9vrquMK/0mvf6RWwMERU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=a6GmPJVjKfLp+Flw8jMx/2luN1LxfuSATEVD8/2bO1C17CYfONX3hyEDxH97rqEIb
         TtJLJehfyRmE/sAQwSX5SAtWHcJj/McqEg6BU/842OxiMICr4uKKdP9nnNQPYR0Vxn
         LzE+tslD01yZFKQa56xfhJpB1VxZMhMQFMBbs3/I=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200507094658eucas1p186723bf227b1df6597c3942a4e6bbada~MtfGt-hR41300113001eucas1p1C;
        Thu,  7 May 2020 09:46:58 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 9B.B0.60679.219D3BE5; Thu,  7
        May 2020 10:46:58 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200507094657eucas1p2e785a6b277c732ba4417fa9d1c9c8d5f~MtfGTZuqB0085000850eucas1p2L;
        Thu,  7 May 2020 09:46:57 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200507094657eusmtrp23bad71932a3809fe73fd59cf076708dd~MtfGSr4ze2652826528eusmtrp2i;
        Thu,  7 May 2020 09:46:57 +0000 (GMT)
X-AuditID: cbfec7f4-0e5ff7000001ed07-33-5eb3d912bb2a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 45.21.07950.119D3BE5; Thu,  7
        May 2020 10:46:57 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200507094657eusmtip1eaa1246eb850f8793dfc8ded22397514~MtfFxFBtx1825018250eusmtip1i;
        Thu,  7 May 2020 09:46:57 +0000 (GMT)
Subject: Re: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in
 EXT_RGMII_OOB_CTRL when not needed
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <cf07fae3-bd8f-a645-0007-a317832c51c1@samsung.com>
Date:   Thu, 7 May 2020 11:46:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200225131159.26602-1-nsaenzjulienne@suse.de>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUgUYRjm2xlnx83VcTz2VTsXEyq8IwYyu2ULSn9ERbHqpINKrsquR1o/
        LCVz6bREWxVFwROPXDXdH1peW5lrZIcrihhKHqilRimiNY2W/57nfZ7ne98HPhKj9RbOZFRM
        PKeOYaPlhARv6l4yudNmfbDXcB3OVN/rwpn8vnScWZ7tFDP9hnyC6S5yZJp0ZQSzkPUEMcZX
        mdgRUqEb6SUUDRVmkaJFNyxWlNS3EQp9z3XFQv32IOKSxC+ci45K5NSe/qGSSP1CKRE3SV/r
        b8lEqajKRossSaD2Q6chW6xFEpKmyhGkP+60EMgigqyW5nWygMCcM45tRKaK09YjZQhKzD8w
        gcwhyJ98g3iXHRUOuQ++/xXsqbcIhjtGxbyAUSysVa1Y8JigvEE7oyV4LKX8YS6zH9ciksQp
        V8goD+ChA6WEnE/nBIctvH46hvPYkvKDb0UDhPDiDkhrzMMELIPBsUIRvxaoVjFkd6wQwtUn
        IK/GvN7ADqaMDWIBb4W1lo1AGoJRU7VYIHcR9N/KRYLrIAyZlgn+IozaA7UGT2F8FIqbG0T8
        GChrGJixFY6whqymHEwYS+HObVpwu4HOWPNv7ct377GHSK7bVE23qY5uUx3d/71FCK9EMi5B
        o4rgND4xXJKHhlVpEmIiPMJiVfXoz1fqWTUuNiPDypV2RJFIbiV9UVofTFuwiZpkVTsCEpPb
        S61+PQumpeFscgqnjg1RJ0RzmnbkQuJymdS3eFJJUxFsPHeV4+I49YYqIi2dU5FbsktA6+5H
        S8e3jeyrdDygdDo888W1N1sU2DsfS7OmqK5etU+fTdoF8+UbdGiSfZCTSpbvdfbnefPOZSYj
        /eP9i7k5gROFBbVDDmN1reXGzyetTbumVgdOn/rqGxY0e+aQ33zFtHvITf104/S4x/OCD1vo
        Y8rBlJWoCZlEqe/JbpPjmkjWey+m1rC/AXTbhcdGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xu7qCNzfHGVxarGqxtvcoi8Wc8y0s
        Fr/eHWG3uLxrDpvFsQViFttmLWez+DxpCqPF8ROdzA4cHrPun2Xz2LLyJpPHzll32T0Wb9rP
        5rH5dLXH501yAWxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZ
        ZalF+nYJehmbPy9jK3gpVHF5ZydjA+Nq/i5GTg4JAROJV4ua2bsYuTiEBJYySjx+/JcdIiEj
        cXJaAyuELSzx51oXG0TRW0aJvT3P2UASwgIpEjP6PzKDJEQEzjBKfP04lwkkwSyQKLFk304w
        W0jAWuL6kkNgNpuAoUTX2y6wZl4BO4n3nZdZuhg5OFgEVCTaV7iBmKICsRItFzUhKgQlTs58
        wgJicwrYSHxYcIMNYrqZxLzND5khbHmJ5q2zoWxxiVtP5jNNYBSahaR9FpKWWUhaZiFpWcDI
        sopRJLW0ODc9t9hIrzgxt7g0L10vOT93EyMwBrcd+7llB2PXu+BDjAIcjEo8vAeWbYoTYk0s
        K67MPcQowcGsJMLL82NjnBBvSmJlVWpRfnxRaU5q8SFGU6DXJjJLiSbnA9NDXkm8oamhuYWl
        obmxubGZhZI4b4fAwRghgfTEktTs1NSC1CKYPiYOTqkGxonVx+sfOQRr39MUehlnP+F5T26x
        pftuJc5pJeLNVyrE3v++02vL+vLKq7wNmSUz8gLMi5u1nEqyo4VratwF1ku8N/JWcPm+btaH
        fE7ZjXwf7kRt3FL+V2Je9Qsd9Qpuo6sPdl3VueAnOq9xcdWvOD6Bzb+d7XhKH9y48vVYxKKy
        L6e3FNh5KrEUZyQaajEXFScCAHE/YSXXAgAA
X-CMS-MailID: 20200507094657eucas1p2e785a6b277c732ba4417fa9d1c9c8d5f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200507094657eucas1p2e785a6b277c732ba4417fa9d1c9c8d5f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200507094657eucas1p2e785a6b277c732ba4417fa9d1c9c8d5f
References: <20200225131159.26602-1-nsaenzjulienne@suse.de>
        <CGME20200507094657eucas1p2e785a6b277c732ba4417fa9d1c9c8d5f@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 25.02.2020 14:11, Nicolas Saenz Julienne wrote:
> Outdated Raspberry Pi 4 firmware might configure the external PHY as
> rgmii although the kernel currently sets it as rgmii-rxid. This makes
> connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
> explicitly clear that bit whenever we don't need it.
>
> Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
> Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

I've finally bisected the network issue I have on my RPi4 used for 
testing mainline builds. The bisect pointed to this patch. Once it got 
applied in v5.7-rc1, the networking is broken on my RPi4 in ARM32bit 
mode and kernel compiled from bcm2835_defconfig. I'm using u-boot to 
tftp zImage/dtb/initrd there. After reverting this patch network is 
working fine again. The strange thing is that networking works fine if 
kernel is compiled from multi_v7_defconfig but I don't see any obvious 
difference there.

I'm not sure if u-boot is responsible for this break, but kernel 
definitely should be able to properly reset the hardware to the valid state.

I can provide more information, just let me know what is needed. Here is 
the log, I hope it helps:

[   11.881784] bcmgenet fd580000.ethernet eth0: Link is Up - 1Gbps/Full 
- flow control off
[   11.889935] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

root@target:~# ping host
PING host (192.168.100.1) 56(84) bytes of data.
 From 192.168.100.53 icmp_seq=1 Destination Host Unreachable
...

> ---
>
> Changes since v1:
>   - Fix tags ordering
>   - Add targeted tree
>
>   drivers/net/ethernet/broadcom/genet/bcmmii.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index 6392a2530183..10244941a7a6 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -294,6 +294,7 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
>   	 */
>   	if (priv->ext_phy) {
>   		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
> +		reg &= ~ID_MODE_DIS;
>   		reg |= id_mode_dis;
>   		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
>   			reg |= RGMII_MODE_EN_V123;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

