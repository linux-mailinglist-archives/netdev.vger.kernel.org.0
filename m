Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A813968F0DA
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjBHObb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjBHOba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:31:30 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9005C95;
        Wed,  8 Feb 2023 06:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1675866653;
        bh=23X5TX+ESt6P/v6NFPb3Xe184rfenm6WbYS+JlMi6jE=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=hdYqMIiBNAf/HN7Pxx3BF4z56sGOwZ+HAkIGgRreOLjSYd3KBjc2T2vrqeAqVcj6A
         LX5q3AiAHGK82XxIqsCf+km7HnQOzdWvLnd7/0dfIbkUWRcbj4rul9OY16pe8my/K8
         mWBDXr9NPdzEDNo1xpTBMgMOFkZhuOMFRGVNRglSMPqZsJXuoV1p/QBy191E425Nho
         NWVXQCXUWMRBLGjANm9A3UtXe1mwEMho0b0lKU7VgU7rxNyp7bgeeCa38oEu1Gh9tg
         R62W8zrSsiy78mzGCOxff1288Yp4R3uroMmgMMjMUVB8Dp5IpaupAIHHLSTT8lUhNU
         as+e/D9UowduA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([157.180.227.18]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mnpns-1ondR84BFC-00pP73; Wed, 08
 Feb 2023 15:30:53 +0100
Date:   Wed, 08 Feb 2023 15:30:49 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
CC:     arinc9.unal@gmail.com, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net=5D_net=3A_ethernet=3A_mtk=5Feth=5Fsoc?= =?US-ASCII?Q?=3A_enable_special_tag_when_any_MAC_uses_DSA?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <20230207155801.3e6295b0@kernel.org>
References: <20230205175331.511332-1-arinc.unal@arinc9.com> <20230207105613.4f56b445@kernel.org> <5d025125-77e4-cbfb-8caa-b71dd4adfc40@arinc9.com> <52f8fc7f-9578-6873-61ae-b4bf85151c0f@arinc9.com> <20230207155801.3e6295b0@kernel.org>
Message-ID: <EAD9D5DE-571F-4D59-9F09-1B3C8F23ABCF@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EqlMNzwFUzUkFtQzw+PYkXe8Z7nZzAYLh3DyUnjXSbMS4TG9Q2B
 GpTBMhn+nciUSrAlKoUpi0W7L0ejEnQuf6mx9U6hcuyYrls/+ZcPObMLSZ1RKbc7rEben6B
 t98cuSi6LRkvFN/zLnCIvaPbVvbH5JEUzJjm86LWP4BURAIkPrcl8vTsmqe4z+SoPfvkXgc
 F+IXFV1e6yA1aWrrVtHRw==
UI-OutboundReport: notjunk:1;M01:P0:leBRI6KhA0A=;SLewI2BJYjFVUaec1eIR4K21TPa
 CXaWujmp4/MCq15RQ6fElwypLw0s8OXmycTfj8oIcRcb131rwubDTlaat/3z8g3oBA8Cnui9r
 5eeCx4R+PHOSG8qFv8QoYcjNR9iNezWvZrvAgp7kpE//fVCMWc00XY1PwcmnIv//6fNMMQEmV
 aOoWRwCGGI64BHI4tcSUyuV2/cqkWAd7VUtEPjG7nmBPeAGEzVnuyGxUnN5TWIAKhbMZPqtol
 GlBEzFrkpuZH0WiO+0lg/gM7QzmawwxzsnFBJqDUUwpjWjyV40/WeHX9NbOPWOiIQmy2sdD1w
 7hRVKCi0ybpCxcj8+j9aVRKOGNvzUQ/OmSZTjuDb/wOmowwImmoSLLaCVdb7lkuc+KlXOT2bb
 Y4lUwPmRVel/nWnzo+DNrA3AGj+j9auf7H7MHuLnbfFsr7XxZTe0FKhgt4Yse2dMudySCTzLu
 nT2AW+9GLWDbtCuRTMfEBPkAYmVfmA+GzDjKwdr9FpSOYFp1dYoSWIzDlrl8QRYbDWE1g4Oi0
 wwgI5FLP6aBGSC0WTA6SG3hkNAZ1jBnfjYTwqcR+C9OnMi9tyQm9nUOMyRBHdnTnzw2ui1Ora
 euI9DOGdZg17YD0nPDATkFwnUIXo6c64S0DUeMlodDi1KB5B97E+8GhrdLx/UqNLAHfQ+ToDy
 eA+h+EZU+u/37wjDZ3GzUmvav0n5Q7hDxvrb2HAYnAHVUWrJ1PE15GYW5zWvo0R41BzufoJTO
 BkJ2FGBc26uQc4ZFqsyqmJNAtyd3hY/2/Oke9QwPrUrbrIrDXVoxA/7fFD8u1wdmLXHzwCab/
 Wj7EHDXhagxNd8b4ntzgLVFZgkSJ/efDpRt6HeFiVzk6BgfhPOOzmEt0gt4kZwNAmLZo5J7DH
 LaefLCP0EPSK4hsUNV4hcJXpqtEjmtq5V/v5Zw2GaY8zFPVUvvmez7fVb9bJyOEvIKxrTQ54d
 WdZDH4wd9rXHewKMlyBuFs9K6Hs=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 8=2E Februar 2023 00:58:01 MEZ schrieb Jakub Kicinski <kuba@kernel=2Eorg=
>:
>
>No strong preference, TBH=2E
>
>The motivation for my question was to try to figure out how long we
>should wait with applying this patch=2E I applied the commit under Fixes
>without waiting for a test from Frank, which made me feel a bit guilty
>:)

No worry=2E You don't have to feel guilty for it=2E

My limited time currently does not allow test all patches in all circumsta=
nces=2E=2E=2Ei trust arinc to make it better than before=2E=2E=2Ethere are =
many patches floating around which fixing some corner cases in mtk eth driv=
er=2E I hope these are applied i had tested and for the others i report a b=
ug when i notice any problem :)

Would be nice if felix' series can be merged for fixing sw vlan on non-dsa=
 mac and the one from vladimir fixing the vlan_aware bridge without breakin=
g dsa port outside the bridge on same gmac=2E
regards Frank
