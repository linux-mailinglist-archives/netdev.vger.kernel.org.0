Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B47E1868BA
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgCPKKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:10:19 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57544 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730468AbgCPKKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 06:10:19 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D3820B8005D;
        Mon, 16 Mar 2020 10:10:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 16 Mar
 2020 10:10:09 +0000
Subject: Re: [PATCH net-next] sfc: fix XDP-redirect in this driver
To:     David Miller <davem@davemloft.net>, <brouer@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <mhabets@solarflare.com>, <cmclachlan@solarflare.com>,
        <ilias.apalodimas@linaro.org>, <lorenzo@kernel.org>,
        <sameehj@amazon.com>
References: <158410589474.499645.16292046086222118891.stgit@firesoul>
 <20200316.014927.1864775444299469362.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <98fd3c0c-225b-d64c-a64f-ca497205d4ce@solarflare.com>
Date:   Mon, 16 Mar 2020 10:10:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200316.014927.1864775444299469362.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25294.003
X-TM-AS-Result: No-4.813500-8.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/vmLzc6AOD8DfHkpkyUphL9OhJ9m53n4aCnRvssirgAKwjy
        Lz97jpWXIWlA6ZCW3obTasKNAsDoKR8tmNEYF19BB/XUnmGGOOo0AJe3B5qfBq9Lm2QTZkUysFm
        zNLPWp6JkkHS2hDrybjQUkohHLxxa6KaQp82NJhyJUlmL3Uj0mHLhUU/qa4OGKsMDWBh/KG/86j
        jqq+KUSoqMdg748W15X7bicKxRIU0s+iG3EbsYW2rz/G/ZSbVq+gtHj7OwNO0tCv406fddlkAk5
        6HY2n/SQXvNDXsdpAFUG3g6/s7zdNDEFg4nMt6ahHBrkFXfKEffK9hKR0xpHCoFsMboK35ckiE4
        nqliHU2y69/6UHLt/YfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7YDttQUGqHZU=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.813500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25294.003
X-MDID: 1584353418-djAZ8Xae168p
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2020 08:49, David Miller wrote:
> Solarflare folks, please review.
This looks like a correct implementation of what it purports to do, so
Acked-by: Edward Cree <ecree@solarflare.com>
It did take me some digging to understand _why_ it was needed though;
 Jesper, is there any documentation of the tailroom requirement?  It
 doesn't seem to be mentioned anywhere I could find.
(Is there even any up-to-date doc of the XDP driver interface?  The
 one at [1] looks a bit stale...)
-Ed

[1]: https://prototype-kernel.readthedocs.io/en/latest/networking/XDP/design/requirements.html
