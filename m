Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0C542C5C0
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhJMQFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:05:22 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:48522 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhJMQFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:05:21 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 9781420A4E41
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org\"" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "Prabhakar Mahadev Lad" <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
 <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
 <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <8b261e85-4aa3-3d58-906d-4da931057e96@gmail.com>
 <OS0PR01MB592259FBB622ECABF6ED250486B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <0517bd54-2da8-82cb-c844-bd5b73febd8f@omp.ru>
 <20211013085704.4a059444@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <52132e66-79e4-8e0e-82bc-5aa16f00175f@omp.ru>
Date:   Wed, 13 Oct 2021 19:03:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211013085704.4a059444@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 6:57 PM, Jakub Kicinski wrote:

>>    Ah, I think it's the (usual) checksum-vs-CRC mixup. I don't know
>> why TOE needs CRC tho but it's 4 bytes at the end of a frame, not
>> having much toi do with the 2-byte checksums...

   s/toi/to/.

> Meaning v3 is good as is? I'm trying understand if I should apply it ;)

   Yes, I'm giving up (-:

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

MBR, Sergey
