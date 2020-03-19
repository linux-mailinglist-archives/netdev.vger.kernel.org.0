Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F9918C093
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCSTlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:41:44 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:58196 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgCSTlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 15:41:44 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9FF824C006D;
        Thu, 19 Mar 2020 19:41:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 19 Mar
 2020 19:41:36 +0000
Subject: Re: [PATCH 13/29] netfilter: flowtable: add tunnel match offload
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <wenxu@ucloud.cn>
References: <20200318003956.73573-1-pablo@netfilter.org>
 <20200318003956.73573-14-pablo@netfilter.org>
 <72f9e0d8-56ac-aa01-63d1-9ffdab8c13c4@solarflare.com>
 <20200319193534.7s6aw2xn5xzoebjn@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0b0d0d2d-b8fa-41d6-80f3-adead45159b6@solarflare.com>
Date:   Thu, 19 Mar 2020 19:41:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200319193534.7s6aw2xn5xzoebjn@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25300.003
X-TM-AS-Result: No-3.514300-8.000000-10
X-TMASE-MatchedRID: fgYTp5XatxYbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizyYkF7ZtFfCU4Ml
        jSaf/4d1slVouE/7acLzlKLUvzV/irgnc7sA9C3/mvnKSb020hylhc243Qzx9Zsoi2XrUn/JIq9
        5DjCZh0zpd+/rcvUW9gtuKBGekqUpm+MB6kaZ2g5dADOiNxmvxJOpSWvJHEdwXpx3KSlxzYD11d
        jw1pNxfRaB5sToB7+pgE+qXrodlyP2D0lt87kcSEI+6jmu6w6OqAV99+S8vmSHzGTHoCwyHhlNK
        Sp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.514300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25300.003
X-MDID: 1584646903-Jo9j3tRpX2OA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/03/2020 19:35, Pablo Neira Ayuso wrote:
> Would this test this patch?
>
> https://patchwork.ozlabs.org/patch/1257949/
I've tested with an added check on other_dst (same as the first hunk
 of that patch), and it fixed the issue in my case.

-ed
