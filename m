Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E110264178E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 16:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLCPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 10:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLCPix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 10:38:53 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9232C2189C
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 07:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1670081900;
        bh=LMmd3kLwQyhE5ofdcfycINcA+8R6j65sW2cAZ8RvgP8=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=bqkH3cy7I5nD16FJL67QN9OnJi1/HiisQsO2Nr5JJuNqwRrpJ4I8xm7UfPjFINDwu
         XdSziYkiJbnltu0eX6MJgS+92u+AnJX99EHPrmAZdI5DtVFaHVUQ6n54CA2A6FmGvy
         p9WzdxhJOR3vL5nLcUbxM//qO27VWRuzx2FUoBzPzOCkiyrf4r4BU+c1KTOU6OTySm
         uDRYZRhGvYL9yNdu3u0E2qYWOHrggrZpzV+W2fL4JfezHt3r/Z9Y9QdnsDZDvBzvnK
         djTKzenaZqENJy7hh4V1n2hYtUg/M5Jux3UlBPCTcrI8GdOdjx1191UJtlPoTZLAOR
         qUziySCcwtKDw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([217.61.153.36]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N1fii-1oqWF13QyG-01205a; Sat, 03
 Dec 2022 16:38:19 +0100
Date:   Sat, 03 Dec 2022 16:38:15 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     linux-mediatek@lists.infradead.org,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
CC:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        sujuan.chen@mediatek.com, lorenzo.bianconi@redhat.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next=5D_net=3A_mtk=5Feth=5Fsoc=3A_e?= =?US-ASCII?Q?nable_flow_offload_support_fot_MT7986_SoC?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <fdcaacd827938e6a8c4aa1ac2c13e46d2c08c821.1670072898.git.lorenzo@kernel.org>
References: <fdcaacd827938e6a8c4aa1ac2c13e46d2c08c821.1670072898.git.lorenzo@kernel.org>
Message-ID: <70E22A48-DEE2-403A-975F-AD7D418B78CA@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+wZMhqeLkJBVWC0oqLGK1e28b9LF9DIas5xyT+HVlpCGrluW6oR
 siY9gVpJSWc9mbqkI/d/jEmyYBObU2pU3IbGcygpx9h3M9HfxGRk+6/Ye039ywRlf4eiIgQ
 FPfQ4rYuINQB/GTPOng3YMtQX0s+R68ddQWlWL46mI45wq4GnC6i+QYtWJkdyL4ZGa5XW/Y
 mKMmdQfOM+8hC/br2sJ5g==
UI-OutboundReport: notjunk:1;M01:P0:Gup6pCVehY4=;v3OaVv/4gGIF6XUeZ/hh2yBlxsQ
 emvgEbo1cxfFaEpZr8EEptnxirpGfdc3JKw4TTB188uDTqNel4pWfpiPAfq7qFyHwAnbbxPEJ
 kwrJeis5IS9jN9/aW0GECmpDKmUmYkjxtaXmNFjKR+b7OPet3Y0fiix/2QWkaL7LQg3OYMsD+
 hgOuuQLtQRmzrz3UJqNpniLErmf6VYCj2DScP/HHz6Ow54tYW/kRflUONPs/vzTbG2dKx2ipm
 sVaB49RR9FCl2yI/fhn4v8ESCkTZkdsLQLzO/v+HknnlyjsmX+gSTQoShjc8+BCYt5Wpi81lZ
 0ngii+3ztWIkpVhw659e53Xojce4Z3LJo/AY1IHcqjThvjtg3LMNiIJ39bkWYIwL2GYR0OMHD
 T28LrGW3wZVQ50ZiqXUKgqTOxRoRBAjz8TS3Uz7BxUkZ0N1sKzm7xbGkO9Ne/WghzHdPzVP5w
 pKXiUEcwmz+6LTl9x7K3JJBy7X9GEnh4xaGQ2LKRhuJLFk41CBotfOo2qhjWs4d6yf4jeh92N
 /ZLJlfI9pBFfTAi5j6KGjjBsjMU7+Anop9B0vjAEsDyAwOpX815EsfJyMw85fx1Bnp2RwvFYX
 OBPRlQpL12EcOFgyKewp9OmF/rp7z5356IQgsNACFji0VzoJ7IcBkFBDDoTKJpLm/cO4USUme
 MmX7WeQcPxF6kgWtWW5iObvNnD14tVncztUGn1Lkf6UzpQfRZCsn9bfw14a9wmCQnvVsq+FkD
 UyWqfUvH1LZHvqjBQ8vSOclJCByGRPYysPQfuZ0R6sXdA77XGgxqCEWOnYjdt5PqW/qEJNXR/
 8jxcNH4nufWUavE3qKPmVVtOQUP4Jy2965thC94JNfpOYuYrsbqkU97uiAlz8F1gaij3yyZHy
 Jwu/lN558R+rrE9/WY2O3ur549XUYa6GHPdHQAwDuclBFPaR81ekWUqaQmBg0l05Y1rLDrOu/
 ScMmOw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

thanks for the Patch, i only noticed a typo in Subject (s/fot/for/)=2E
regards Frank
