Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD47663CB7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbfGIU1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:27:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59796 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729532AbfGIU1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:27:17 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1904428006A;
        Tue,  9 Jul 2019 20:27:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 9 Jul
 2019 13:27:11 -0700
Subject: Re: [PATCH v5 bpf-next 0/4] capture integers in BTF type info for map
 defs
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>, <ast@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20190705155012.3539722-1-andriin@fb.com>
 <86f8f511-655c-bf9e-8d78-f2e3f65efdb9@iogearbox.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0366eaff-b617-b88a-ade4-b9ee8c671e18@solarflare.com>
Date:   Tue, 9 Jul 2019 21:27:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <86f8f511-655c-bf9e-8d78-f2e3f65efdb9@iogearbox.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24748.005
X-TM-AS-Result: No-7.363700-4.000000-10
X-TMASE-MatchedRID: HXSqh3WYKftdXzNMq6eeyfZvT2zYoYOwC/ExpXrHizz5+tteD5Rzhdtu
        Lnl6rSi7Kem1U0hJhx95jH2IuAdMb0ohWBZ4QV+6HC7hAz/oKnKiIpNv3rjMdbOG3u14VtmeIQw
        dt8FiOhSM1jiYzFccnt2OAL+ZVmrFg3TczpWnIuf0VCHd+VQiHlsP0tBwe3qDT9xG+Pmy0/rJlk
        /oeUvTYBeLJo0fZiX0tA0zKb5G1ubFRwb1XqfjK54CIKY/Hg3AnCGS1WQEGtDGr09tQ7Cw/1BIV
        svVu9ABwrbXMGDYqV+BMV0kqc2hZImLHHJNXBnQvVOAT9iSBnkdS1Ocvif3bKx0TdNEHAFeVlxr
        1FJij9s=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.363700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24748.005
X-MDID: 1562704036-W9EV6BCCp0U5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/07/2019 22:15, Daniel Borkmann wrote:
> On 07/05/2019 05:50 PM, Andrii Nakryiko wrote:
>> This patch set implements an update to how BTF-defined maps are specified. The
>> change is in how integer attributes, e.g., type, max_entries, map_flags, are
>> specified: now they are captured as part of map definition struct's BTF type
>> information (using array dimension), eliminating the need for compile-time
>> data initialization and keeping all the metadata in one place.
>>
>> All existing selftests that were using BTF-defined maps are updated, along
>> with some other selftests, that were switched to new syntax.
BTW is this changing the BTF format spec, and if so why isn't it accompanied by
 a patch to Documentation/bpf/btf.rst?  It looks like that doc still talks about
 BPF_ANNOTATE_KV_PAIR, which seems to be long gone.

-Ed
