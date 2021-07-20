Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E7E3CFA18
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhGTM0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:26:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11458 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbhGTMZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:25:17 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GTf4n4qbszcgM4;
        Tue, 20 Jul 2021 21:02:17 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 20 Jul 2021 21:05:39 +0800
Subject: Re: Ask for help about bpf map
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dahern@digitalocean.com>
References: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
 <CAEf4BzZpSo8Kqz8mgPdbWTTVLqJ1AgE429_KHTiXgEVpbT97Yw@mail.gmail.com>
 <8735sidtwe.fsf@toke.dk> <d1f47a24-6328-5121-3a1f-5a102444e50c@huawei.com>
 <26db412c-a8b7-6d37-844f-7909a0c5744b@huawei.com>
 <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
 <CAADnVQJYhtpEcvvYfozxiPdUJqcZiJxbmT2KuOC6uQdC1VWZVw@mail.gmail.com>
 <6b659192-5133-981e-0c43-7ca1120edd9c@huawei.com> <87wnpmtr5j.fsf@toke.dk>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <beb37418-4518-100a-5b1b-e036be6f71b6@huawei.com>
Date:   Tue, 20 Jul 2021 21:05:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87wnpmtr5j.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's very strange, in my virtual host, it is:

$ ip -V

ip utility, iproute2-5.11.0


but in my physical host:

$ ip -V
ip utility, iproute2-5.11.0, libbpf 0.5.0


I compiled iproute2 in the same way as I mentioned previously, and the 
kernel versions are both 5.13 (in fact the same code) .


在 2021/7/19 8:38 PM, Toke Høiland-Jørgensen 写道:
> "luwei (O)" <luwei32@huawei.com> writes:
>
>> Andrii and Toke inspired me. You are right, the libbpf version should be included in -V output
>> , but not mine. I searched google and found this page: https://www.spinics.net/lists/netdev/msg700482.html
>> , according which I re-compiled iproute2 and it works.
> Did the libbpf version appear in the output of 'ip -V' after you
> recompiled and enabled it? It does in mine:
>
> $ ./ip/ip -V
> ip utility, iproute2-5.13.0, libbpf 0.4.0
>
> -Toke
>
> .

-- 
Best Regards,
Lu Wei

