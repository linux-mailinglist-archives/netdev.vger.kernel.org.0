Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30F28BB34
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfHMOLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:11:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:41180 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbfHMOLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:11:55 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxXWb-0003nq-Th; Tue, 13 Aug 2019 16:11:45 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxXWb-000Oie-IB; Tue, 13 Aug 2019 16:11:45 +0200
Subject: Re: libbpf distro packaging
To:     Jiri Olsa <jolsa@redhat.com>, Julia Kartseva <hex@fb.com>
Cc:     "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eb5cf65a-1aa0-fde4-e726-41a736cb7314@iogearbox.net>
Date:   Tue, 13 Aug 2019 16:11:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190813122420.GB9349@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25540/Tue Aug 13 10:16:47 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 2:24 PM, Jiri Olsa wrote:
> On Mon, Aug 12, 2019 at 07:04:12PM +0000, Julia Kartseva wrote:
>> I would like to bring up libbpf publishing discussion started at [1].
>> The present state of things is that libbpf is built from kernel tree, e.g. [2]
>> For Debian and [3] for Fedora whereas the better way would be having a
>> package built from github mirror. The advantages of the latter:
>> - Consistent, ABI matching versioning across distros
>> - The mirror has integration tests
>> - No need in kernel tree to build a package
>> - Changes can be merged directly to github w/o waiting them to be merged
>> through bpf-next -> net-next -> main
>> There is a PR introducing a libbpf.spec which can be used as a starting point: [4]
>> Any comments regarding the spec itself can be posted there.
>> In the future it may be used as a source of truth.
>> Please consider switching libbpf packaging to the github mirror instead
>> of the kernel tree.
>> Thanks
>>
>> [1] https://lists.iovisor.org/g/iovisor-dev/message/1521
>> [2] https://packages.debian.org/sid/libbpf4.19
>> [3] http://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/l/libbpf-5.3.0-0.rc2.git0.1.fc31.x86_64.html
>> [4] https://github.com/libbpf/libbpf/pull/64
> 
> hi,
> Fedora has libbpf as kernel-tools subpackage, so I think
> we'd need to create new package and deprecate the current
> 
> but I like the ABI stability by using github .. how's actually
> the sync (in both directions) with kernel sources going on?

The upstream kernel's tools/lib/bpf/ is always source of truth. Meaning, changes need
to make it upstream first and they are later synced into the GH stand-alone repo.

Thanks,
Daniel
