Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960DFFB791
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfKMSaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:30:19 -0500
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:47620 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbfKMSaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 13:30:19 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3DDD7480079;
        Wed, 13 Nov 2019 18:30:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 13 Nov
 2019 18:30:07 +0000
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com>
 <20191112231822.o3gir44yskmntgnq@ast-mbp.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0c90adc4-5992-8648-88bf-4993252e8992@solarflare.com>
Date:   Wed, 13 Nov 2019 18:30:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191112231822.o3gir44yskmntgnq@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25040.003
X-TM-AS-Result: No-11.123400-8.000000-10
X-TMASE-MatchedRID: gTucSmrmRMPmLzc6AOD8DfHkpkyUphL9WDtrCb/B2hD4qcrtH/xgFZG7
        2NzIAVHbSR6AUQrJJcuJjnQgB0y4MyH/qIKp8YHgzYdkhvBj72YGchEhVwJY3/yQXCBzKijhKMB
        +A3R9wpjQnvspXsHGGjgVYVRiAYcYIly/lfs5uYll2ityh8f8abzETYfYS4xZkYldHqNEW7jVYV
        lghh6bHLbVdljeKYS0SxgQeJeJcbtveCKWtaLcaNz4Qeg3eDOXNACXtweanwY26TIMgH4duvlgF
        +Kg8U8ROcDxuFovi7sJc76c84YQtEY1icyaSXl7iVJZi91I9JipXdWa4gU0SyuGKh4AkqKVTx7y
        4qsCFyjPNMvOUpFAAcC9Ectx7blhS6sB4alhNseSa1tNw2nFhJmuAlCliTSzSsLSc3Pt6d8cM+9
        sw875Dq0O70YxrIQWboiPOocsN2Rzzu7iu0I3xElR2DE0NRda3V4UShoTXaeZt08TfNy6OGUsfN
        azqaz0vi+sWY5pLUTAAptcaK2X1JH+r1dm7Q1Zec1y1wrvN8VRGnhVKO1nEseQfu6iwSfsL3cbW
        SYN50zZT+PYC0MLLugYO29BmH8mcD+UkqIXD16Ev01fZOqaQPf6ZSoNZQrIIyM6bqaAlytOoawJ
        u9w+jEGuPlleiAosuiY3Jd7OxZ1JT04BD0+0vjBgCmbnj9JmfS0Ip2eEHnzUHQeTVDUrItRnEQC
        UU+jz9xS3mVzWUuA4wHSyGpeEevhHs6Nly492z6NxPA1Vi8Bk1F/HwgJmfnmyphMWrxPqzp5NFf
        iy5h8=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.123400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25040.003
X-MDID: 1573669818-l01CeIA_ftqE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2019 23:18, Alexei Starovoitov wrote:
> On Tue, Nov 12, 2019 at 09:25:06PM +0000, Edward Cree wrote:
>> Fwiw the 'natural' C way of doing it would be that for any extern symbol in
>>  the C file, the ELF file gets a symbol entry with st_shndx=SHN_UNDEF, and
>>  code in .text that uses that symbol gets relocation entries.  That's (AIUI)
>>  how it works on 'normal' architectures, and that's what my ebld linker
>>  understands; when it sees a definition in another file for that symbol
>>  (matched just by the symbol name) it applies all the relocations of the
>>  symbol to the appropriate progbits.
>> I don't really see what else you could define 'extern' to mean.
> That's exactly the problem with standard 'extern'. ELF preserves the name only.
> There is no type.
But if you have BTFs, then you can look up each symbol's type at link time and
 check that they match.  Point being that the BTF is for validation (and
 therefore strictly optional at this point) rather than using it to identify a
 symbol.  Trouble with the latter is that BTF ids get renumbered on linking, so
 any references to them have to change, whereas symbol names stay the same.

> There is also
> no way to place extern into a section. Currently SEC("..") is a standard way to
> annotate bpf programs.
While the symbol itself doesn't have a section, each _use_ of the symbol has a
 reloc, and the SHT_REL[A] in which that reloc resides has a sh_info specifying
 "the section header index of the section to which the relocation applies."  So
 can't that be used if symbol visibility needs to depend on section?  Tbh I
 can't exactly see why externs need placing in a section in the first place.

> I think reliable 'extern' has to have more than just
> name. 'extern int foo;' can be a reference to 'int foo;' in another BPF ELF
> file, or it can be a reference to 'int foo;' in already loaded BPF prog, or it
> can be a reference to 'int foo;' inside the kernel itself, or it can be a
> reference to pseudo variable that libbpf should replace. For example 'extern
> int kernel_version;' or 'extern int CONFIG_HZ;' would be useful extern-like
> variables that program might want to use. Disambiguating by name is probably
> not enough. We can define an order of resolution. libbpf will search in other
> .o first, then will search in loaded bpf progs, than in kernel, and if all
> fails than will resolve things like 'extern int CONFIG_HZ' on its own. It feels
> fragile though.
It sounds perfectly reasonable and not fragile to me.  The main alternative
 I see, about equally good, is to not allow defining symbols that are already
 (non-weakly) defined; so if a bpf prog tries to globally declare "int CONFIG_HZ"
 or "int netif_receive_skb(struct sk_buff *skb)" then it gets rejected.

> I think we need to be able to specify something like section to
> extern variables and functions.
It seems unnecessary to have the user code specify this.  Another a bad
 analogy: in userland C code you don't have to annotate the function protos in
 your header files to say whether they come from another .o file, a random
 library or the libc.  You just declare "a function called this exists somewhere
 and we'll find it at link time".

> I was imagining that the verifier will do per-function verification
> of program with sub-programs instead of analyzing from root.
Ah I see.  Yes, that's a very attractive design.

If we make it from a sufficiently generic idea of pre/postconditions, then it
 could also be useful for e.g. loop bodies (user-supplied annotations that allow
 us to walk the body only once instead of N times); then a function call just
 gets standard pre/postconditions generated from its argument types if the user
 didn't specify something else.

That would then also support things like:
> The next step is to extend this thought process to integers.
> int foo(struct xdp_md *arg1, int arg2);
> The verifier can check that the program is valid for any valid arg1 and
> arg2 = mark_reg_unbounded().
... this but arg2 isn't unbounded.
However, it might be difficult to do this without exposing details of the
 verifier into the ABI.  Still, if we can it sounds like it would make John
 quite happy too.  And of course it doesn't need to have the user annotations
 from the beginning, it can start out as just the kernel generating pre/post
 conditions internally.

-Ed
