Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6377F35E92F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348652AbhDMWpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbhDMWp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:45:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F612C061574;
        Tue, 13 Apr 2021 15:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=RAw2qFQbXd7DiL7NeB24qBmFpk5WEU6Gl+fX1sTMH9Q=; b=goaoSHSeWGsUmwrE7A5ZucTAPe
        I3m7d4EPs1uSCkvSX3pXTK86WTdllKHtVjvzeWJB6Cj2q4Q2dMPWr4PTbm+MKvVq9indhVry3Uxqk
        z0dz6iZjc9esbXxMbYdzkl8AXQvs17JCkgToIQ5bsf4PQMEMPDIx9FUj7fXrauQWVihGlM3PmQDjC
        RVBItRJnOiuVAS4Fkrew5UZKqwv7DSIxORHxHoxM88qWrsGF1NFJSttbsO2WuGRHRJDfCYCKuR6D3
        puA9vpSK1KhL4pXB+Hs0GmUHQFpszZ1Ea7dWDaqaAx9sIGX4fljKf/4/wvIBfTm13UWiMHt/N5cCn
        Xz0iBUVg==;
Received: from [2601:1c0:6280:3f0::e0e1]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lWRln-006LQJ-UH; Tue, 13 Apr 2021 22:44:39 +0000
Subject: Re: mmotm 2021-04-11-20-47 uploaded (bpf: xsk.c)
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        mhocko@suse.cz, Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        mm-commits@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20210412034813.EK9k9%akpm@linux-foundation.org>
 <7208c4e4-8ff1-7e0d-50ad-6b0aae872a6d@infradead.org>
 <CAEf4BzZBHUX=8=FYwq0bp6GFkOTxCbtiJN31SSoWCsMyh7_hMg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <034959c7-c70f-4d1b-0fe2-dcc00075807f@infradead.org>
Date:   Tue, 13 Apr 2021 15:44:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZBHUX=8=FYwq0bp6GFkOTxCbtiJN31SSoWCsMyh7_hMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 3:18 PM, Andrii Nakryiko wrote:
> On Mon, Apr 12, 2021 at 9:38 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> On 4/11/21 8:48 PM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2021-04-11-20-47 has been uploaded to
>>>
>>>    https://www.ozlabs.org/~akpm/mmotm/
>>>
>>> mmotm-readme.txt says
>>>
>>> README for mm-of-the-moment:
>>>
>>> https://www.ozlabs.org/~akpm/mmotm/
>>>
>>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>>> more than once a week.
>>>
>>> You will need quilt to apply these patches to the latest Linus release (5.x
>>> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
>>> https://ozlabs.org/~akpm/mmotm/series
>>>
>>> The file broken-out.tar.gz contains two datestamp files: .DATE and
>>> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
>>> followed by the base kernel version against which this patch series is to
>>> be applied.
>>>
>>> This tree is partially included in linux-next.  To see which patches are
>>> included in linux-next, consult the `series' file.  Only the patches
>>> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
>>> linux-next.
>>>
>>>
>>> A full copy of the full kernel tree with the linux-next and mmotm patches
>>> already applied is available through git within an hour of the mmotm
>>> release.  Individual mmotm releases are tagged.  The master branch always
>>> points to the latest release, so it's constantly rebasing.
>>>
>>>       https://github.com/hnaz/linux-mm
>>>
>>> The directory https://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
>>> contains daily snapshots of the -mm tree.  It is updated more frequently
>>> than mmotm, and is untested.
>>>
>>> A git copy of this tree is also available at
>>>
>>>       https://github.com/hnaz/linux-mm
>>
>> on x86_64:
>>
>> xsk.c: In function ‘xsk_socket__create_shared’:
>> xsk.c:1027:7: error: redeclaration of ‘unmap’ with no linkage
>>   bool unmap = umem->fill_save != fill;
>>        ^~~~~
>> xsk.c:1020:7: note: previous declaration of ‘unmap’ was here
>>   bool unmap, rx_setup_done = false, tx_setup_done = false;
>>        ^~~~~
>> xsk.c:1028:7: error: redefinition of ‘rx_setup_done’
>>   bool rx_setup_done = false, tx_setup_done = false;
>>        ^~~~~~~~~~~~~
>> xsk.c:1020:14: note: previous definition of ‘rx_setup_done’ was here
>>   bool unmap, rx_setup_done = false, tx_setup_done = false;
>>               ^~~~~~~~~~~~~
>> xsk.c:1028:30: error: redefinition of ‘tx_setup_done’
>>   bool rx_setup_done = false, tx_setup_done = false;
>>                               ^~~~~~~~~~~~~
>> xsk.c:1020:37: note: previous definition of ‘tx_setup_done’ was here
>>   bool unmap, rx_setup_done = false, tx_setup_done = false;
>>                                      ^~~~~~~~~~~~~
>>
>>
>> Full randconfig file is attached.
> 
> What SHA are you on? I checked that github tree, the source code there
> doesn't correspond to the errors here (i.e., there is no unmap
> redefinition on lines 1020 and 1027). Could it be some local merge
> conflict?

Yes, it seems to have been a merge problem in mmotm 2021-04-11.
It is fixed/OK in today's mmotm 2021-04013.

thanks.

-- 
~Randy

