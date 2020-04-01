Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A6319ADC6
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbgDAO0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:26:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40508 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732749AbgDAO0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:26:15 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B8F69200DB;
        Wed,  1 Apr 2020 14:26:14 +0000 (UTC)
Received: from us4-mdac16-13.at1.mdlocal (unknown [10.110.49.195])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B748A800AF;
        Wed,  1 Apr 2020 14:26:14 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.105])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 559BB40073;
        Wed,  1 Apr 2020 14:26:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ED8349C007D;
        Wed,  1 Apr 2020 14:26:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 1 Apr 2020
 15:26:07 +0100
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrey Ignatov" <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
 <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com>
 <CAEf4Bza1ueH=SUccfDNScRyURFoQfa1b2z-x1pOfVXuSpGUpmQ@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e9e81427-c0d7-4a1e-ba9b-c51fd3c683ac@solarflare.com>
Date:   Wed, 1 Apr 2020 15:26:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza1ueH=SUccfDNScRyURFoQfa1b2z-x1pOfVXuSpGUpmQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25326.003
X-TM-AS-Result: No-9.170700-8.000000-10
X-TMASE-MatchedRID: csPTYAMX1+HecRzRckOs5/ZvT2zYoYOwt3aeg7g/usAM74Nf6tTB9sij
        F4UeOUZT7FsIwysVj2VO1SpuqMw3YVJAAk7j9W+XkJi1wdeHFtqcqlCdrhyhQCO7AnsM9hLAXa9
        +3ZJzfMIWf1eVkaUg8CObEUW1s0wmEkhxDD0C3MwD2WXLXdz+AQZyESFXAljfSX8n1Gj4wAE/Fc
        xFvf6KLlTEG0VYp/krlVMZeeAkuNC/WXZS/HqJ2tAtbEEX0MxBxEHRux+uk8h+ICquNi0WJLCxA
        2qCQxM8Ht6Glx7uLSICvd0lnWtVOMmLiOgEMwkoftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.170700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25326.003
X-MDID: 1585751174-9paET6OkOxIX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/04/2020 01:22, Andrii Nakryiko wrote:
> Can you please point out where I was objecting to observability API
> (which is LINK_QUERY thing we've discussed and I didn't oppose, and
> I'm going to add next)?
I didn't say you objected to it.
I just said that you argued that it was OK for it to not land in the
 same release as the rest of the API, because drgn could paper over
 that gap.  Which seems to me to signify a dangerous way of thinking,
 and I wanted to raise the alarm about that.
(If you _don't_ see what's wrong with that argument... well, that'd
 be even _more_ alarming.  Debuggers — and fuser, for that matter —
 are for when things go wrong _in ways the designers of the system
 failed to anticipate_.  They should not be part of a 'normal' work-
 flow for dealing with problems that we already _know_ are possible;
 it's kinda-sorta like how exceptions shouldn't be used for non-
 exceptional situations.)

-ed
