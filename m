Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1BB659A0C
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 16:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbiL3PkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 10:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiL3Pj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 10:39:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82331BE8A;
        Fri, 30 Dec 2022 07:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1672414711;
        bh=PXgBpLfv6zmps2ubfmBnaC3l6JiHs8hMZHegE74QCig=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=r57zXI/9AqdwNHxeVwTYb0sHXuLaBjps6iGPCYFkO42auN42QFIVZ0BMi4TRf5zvH
         aG790Jpwlo9dD3l9Np8aqFi+9slu0lKpmdPkB5q0ufuXeOC5Zn29EccDNQd7ZGdSFa
         4ul25F7QTiYPyub6zXks5NB5SU7l1yQsc9K80BmddAiOu2JVsDWPKf86HX5vrAUXNe
         FS5zAm+dizJOr3+VH9dU1MRwImiZxGMK0bPEvQR281M/PLKAjkpx/1ZjfPRVIZ4zpg
         N3KzQm/mHZGyxqhiftLWrm4XqPQ/wEh16g0utopIOvMYb27iaoXSLaTydLGubusH1H
         gjZOz8KaCcV6A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.221] ([217.61.149.221]) by web-mail.gmx.net
 (3c-app-gmx-bap18.server.lan [172.19.172.88]) (via HTTP); Fri, 30 Dec 2022
 16:38:31 +0100
MIME-Version: 1.0
Message-ID: <trinity-01eda9f9-b989-4554-ba35-a7f7a18da786-1672414711074@3c-app-gmx-bap18>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re:  Re: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop
 generic vlan rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Dec 2022 16:38:31 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <fc09b981-282e-26cd-661e-86fdc72bedf9@nbd.name>
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
 <trinity-a07d48f4-11cf-4a24-a797-03ad4b1150d9-1672400818371@3c-app-gmx-bap18>
 <82821d48-9259-9508-cc80-fc07f4d3ba14@nbd.name>
 <trinity-ace28b50-2929-4af3-9dd2-765f848c4d99-1672408565903@3c-app-gmx-bap18>
 <fc09b981-282e-26cd-661e-86fdc72bedf9@nbd.name>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:Hc5xgZIdWivykrM15O6w7tetFBRZKwZ39+BnbLASnr5yUARV9Q5r80jzVfYDgMqaX1Usk
 CIHLiBcDXXOdnXVK4sAQXKl8qWGnVBAJmaqmCRR3dDjXpqo4RxnbU285W3o9fF6vjt/N8aUui3hc
 iOaA2ZPSv7+E4Np1Km7EaO4mYTcQ1I6d4G1raEiQ2p6sm+0VuEfdvbTVZ7ROm24XbALGy5X+Konf
 lMlmKG4gdO+pkQMwaaHw9rnZjykNm5/tsPh3j0Gy7DpEjfqS11HyChb9/mFng5Cukm6KGCk/We5G
 dk=
UI-OutboundReport: notjunk:1;M01:P0:xFsKZbObyhg=;2c0PqmZ7BUNevu1o4g85HBTrx+D
 vSi2P9IBBl3bNhj58H/X7x+2t57maJMbxo/sJyjupqllNWG6gTCvpIJDosqHcBio6x16GmXDP
 fpqdjlB/s/eyBcPIy+5tC7ohyk/9rPNMqpVULpCP9hc3KioUWZ2iKk5vlgL5ZswO73WGFgAlh
 kD0eGRNZ6HOq10CPImv70EznaAWCf5QmRY9ueHY3zib25EGXw01F3gns6rtM/j72nkJt3RRyz
 29xydZntqewqzaM10et0r2kLbFqmvxICDL7p7DUp34OG18Ztn22rJDV1xQYIiFixBg8vFCFCN
 +5KIShyvFfdn3J+VKLBg8lhbalDd8iQGi+eFHoJpnP7VHIgBVb0Co+ZLxmmjLdLutWYwodIZ9
 PldMu/lhvtK5ct0iqJqk6JS7zdc4mySU9Zq9AzofSkQd+xSesZDXfFXkxuMrRAqy80QzVzt1O
 Nk0ZjpnEPUCdp2TeXxr9apPFWJVLTPHPZR9cKyDf85ynaKcffwXCnCamygiBuYeL0NK1amruD
 7RsHcZNNfHW7K9Frsj5zNe/6KZrQGLd20jMjzAnsfFgz0S9yGaTeVvnAQmibUiSYPkge2L1T2
 BRAjwS/xlk31VmYj9Ly0Pu2J7a3WJCKiJrBZPMTfyHeAQaB/kwh7SZycxYs42bgctDz5mLvyV
 XWdr3jBY4FcGI4srFSFF2ghDWmMsnwoyVjZd2mdoLoAzFyU7wCMmw9xZDtIompAE1M0+GLok8
 IXc9A6QRhilGPbGXyZ5yNRGu8CU97tzFQkNF1UBxgyMUu5KnPNm7q9z0rkW+jHB1qFLoYWXkh
 h4/M0UC5ApqRcgRO7kIU4ihQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

seems only tx is affected on r3, as i see packets on the vlan from my laptop

tcpdump on R3 (e4:b9:7a:f7:c4:8b is mac from laptop):

13:47:05.265508 e4:b9:7a:f7:c4:8b > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 577: vlan 500, p 0, ethertype IPv4 (0x0800), 192.168.50.2.59389 > 192.168.50.255.21027: UDP, length 531
13:47:05.265548 e4:b9:7a:f7:c4:8b > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 577: vlan 600, p 0, ethertype IPv4 (0x0800), 192.168.60.2.59389 > 192.168.60.255.21027: UDP, length 531

regards Frank
