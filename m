Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78180F7661
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKOaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:30:19 -0500
Received: from www62.your-server.de ([213.133.104.62]:42786 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKOaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:30:19 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iUAhs-0000gH-V6; Mon, 11 Nov 2019 15:30:16 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iUAhs-0005R7-IA; Mon, 11 Nov 2019 15:30:16 +0100
Subject: Re: [net-next PATCH] samples/bpf: adjust Makefile and README.rst
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <157340347607.14617.683175264051058224.stgit@firesoul>
 <a1e149a5-af72-0602-d48d-ec7e6939df22@iogearbox.net>
 <20191111145628.23bea8fe@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <da2efacb-b8a9-68e8-c04b-c771aeab26e0@iogearbox.net>
Date:   Mon, 11 Nov 2019 15:30:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191111145628.23bea8fe@carbon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25630/Mon Nov 11 10:59:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/19 2:56 PM, Jesper Dangaard Brouer wrote:
> On Mon, 11 Nov 2019 14:49:51 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 11/10/19 5:31 PM, Jesper Dangaard Brouer wrote:
>>> Side effect of some kbuild changes resulted in breaking the
>>> documented way to build samples/bpf/.
>>>
>>> This patch change the samples/bpf/Makefile to work again, when
>>> invoking make from the subdir samples/bpf/. Also update the
>>> documentation in README.rst, to reflect the new way to build.
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>
>> Please make sure to have bpf@vger.kernel.org Cc'ed in future as well
>> (done here). Given net-next in subject, any specific reason you need
>> this expedited over normal bpf-next route? Looks like there is no
>> conflict either way.
> 
> When I created this patch, bpf-next didn't have the other fixes for
> samples/bpf/.  If you have sync'ed with net-next, then I'm fine with

Correct, as they were just merged by Linus over the weekend. For bpf-next,
we fast-fwd after every PR that is sent for net-next. For fixes the route
is bpf -> net -> linus -> net-next -> bpf-next.

> you taking this change (as it will propagate back to DaveM's tree soon
> enough).

Ok, I don't think the M= adjustment to get it back in line with the samples
README is urgent, but lets go with net-next directly then and have it
propagate back later this week, sent my Acked-by previously for carrying on.

Thanks,
Daniel
