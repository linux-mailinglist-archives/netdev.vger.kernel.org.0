Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F42019A14E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 23:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgCaVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 17:52:05 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47708 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730556AbgCaVwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 17:52:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A7A4320090;
        Tue, 31 Mar 2020 21:52:04 +0000 (UTC)
Received: from us4-mdac16-47.at1.mdlocal (unknown [10.110.50.130])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A581E6009B;
        Tue, 31 Mar 2020 21:52:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3A77322007A;
        Tue, 31 Mar 2020 21:52:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D4A9940005A;
        Tue, 31 Mar 2020 21:52:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 31 Mar
 2020 22:51:53 +0100
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
 <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com>
Date:   Tue, 31 Mar 2020 22:51:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25324.003
X-TM-AS-Result: No-5.242800-8.000000-10
X-TMASE-MatchedRID: wQVy7q402w3ecRzRckOs5/ZvT2zYoYOwC/ExpXrHizzbqdHxGsFfaUIe
        TQRgIkOGsecL7Oo+mNii+GfFnI6aSlI3mP8aC0PBtKV49RpAH3vnEl/YQBxicAzvg1/q1MH2/DA
        gb3IhY2dT7eA6AK2wRl+24nCsUSFNo15kJcETr3lq8/xv2Um1avoLR4+zsDTtviI7BBDiM2Lo7o
        4bTvXunsBRdZrRKwiD3y2w2y6fIOXsxXvKTIGCUg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.242800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25324.003
X-MDID: 1585691524-7orqvsjUOG35
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2020 04:54, Andrii Nakryiko wrote:
> No need to kill random processes, you can kill only those that hold
> bpf_link FD. You can find them using drgn tool with script like [0].
For the record, I find the argument "we don't need a query feature,
 because you can just use a kernel debugger" *utterly* *horrifying*.
Now, it seems to be moot, because Alexei has given other, better
 reasons why query doesn't need to land yet; but can we please not
 ever treat debugging interfaces as a substitute for proper APIs?

</scream>
-ed
