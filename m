Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DAD2B5EC0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 12:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgKQL5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 06:57:09 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.184]:34688 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgKQL5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 06:57:09 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4FDF720078;
        Tue, 17 Nov 2020 11:57:08 +0000 (UTC)
Received: from us4-mdac16-17.at1.mdlocal (unknown [10.110.49.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4C160800A3;
        Tue, 17 Nov 2020 11:57:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D6216100052;
        Tue, 17 Nov 2020 11:57:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 798A0280066;
        Tue, 17 Nov 2020 11:57:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Nov
 2020 11:56:59 +0000
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon> <20201117023757.qypmhucuws3sajyb@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <9a781009-e7e5-4f8c-0e49-bd7386ca5818@solarflare.com>
Date:   Tue, 17 Nov 2020 11:56:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201117023757.qypmhucuws3sajyb@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25794.003
X-TM-AS-Result: No-1.616200-8.000000-10
X-TMASE-MatchedRID: pBwXUM+nCwvmLzc6AOD8DfHkpkyUphL99DmY4JJYLjqOzyCsYRwNaV5X
        KvMz90rKW3I0dGGaO19n86jNK8UwScgDLACebdhjqjZ865FPtpq++TOpgkEMVsO2KBTZiZuoo8W
        MkQWv6iUD0yuKrQIMCKHUf3pt8cg10C1sQRfQzEHEQdG7H66TyHEqm8QYBtMO6evPLtXT51WKCU
        W2lNAiLdrymL0ynPCM/LGiN4MNJtXvqQlwbGo16RZ3CUoM+gEJ40nEG0TFCn9xhzFlmBZJpcNY2
        bKRPim/1DXsKeBNv04EqZlWBkJWd7MZNZFdSWvH4SKOe96QQgc=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.616200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25794.003
X-MDID: 1605614228-i42Abmkal-Gs
X-PPE-DISP: 1605614228;i42Abmkal-Gs
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/11/2020 02:37, Alexei Starovoitov wrote:
> If a company built a bpf-based product and wants to distibute such
> product as a package it needs a way to specify this dependency in pkg config.
> 'tc -V' is not something that can be put in a spec.
> The main iproute2 version can be used as a dependency, but it's meaningless
> when presence of libbpf and its version is not strictly derived from
> iproute2 spec.

But if libbpf is dynamically linked, they can put
Requires: libbpf >= 0.3.0
Requires: iproute-tc >= 5.10
and get the dependency behaviour they need.  No?

-ed
