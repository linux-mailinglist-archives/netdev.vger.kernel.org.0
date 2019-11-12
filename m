Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC80F9C38
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKLVZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:25:27 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:58506 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726906AbfKLVZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:25:27 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8B6FA400098;
        Tue, 12 Nov 2019 21:25:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 Nov
 2019 21:25:10 +0000
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk>
 <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com>
Date:   Tue, 12 Nov 2019 21:25:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25038.003
X-TM-AS-Result: No-3.376300-8.000000-10
X-TMASE-MatchedRID: VfovoVrt/obmLzc6AOD8DfHkpkyUphL92oQN+Q/21gTXLRpcXl5f6Hi1
        9VmdeeTeTEki2VoSh3OahIW1kCatWsuRBwUhxclNBjNCJF/iXbG6s6UL48vRAMsh83hywc54NyR
        9yudqy2SRTH9S8o7AzQlzvpzzhhC0jeydHFnA4nkFKwjjJHbgBFWBVWOe7+fX0HC66mQRqD/V9x
        7gL2l/MkmWjzn4zelHjVwOiEQlwVPUP+i/4eUoEnw6481wsCtCFTFJRL+t8UtGMe+tDjQ3Fq5Pq
        qbCfIUPvgeYjOys8+fl5ftrM+CQ9q+/EguYor8cgxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFlnu+
        TS9e3C7i5vg6AE5Ku30/m/3qz/XjDndCTNqDNTXwPBjnakTbmXW36pe/wPJ5VGl3mPvY+jXOnZY
        ws3d4dGCiAEKXfTTlooBB8uyeEuspZK3gOa9uGmJwouYrZN4qaw+fkLqdalOeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.376300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25038.003
X-MDID: 1573593926-vjhoyKufPu4S
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2019 19:52, Alexei Starovoitov wrote:
> We haven't yet defined what 'extern' keyword in the program means.
> There are a preliminary patches for llvm to support extern variables. Extern
> functions are not done yet. We have to walk before we run. With dynamic linking
> I'm proposing an api for the kernel that I think will work regardless of how
> libbpf and llvm decide to define the meaning of 'extern'.
Fwiw the 'natural' C way of doing it would be that for any extern symbol in
 the C file, the ELF file gets a symbol entry with st_shndx=SHN_UNDEF, and
 code in .text that uses that symbol gets relocation entries.  That's (AIUI)
 how it works on 'normal' architectures, and that's what my ebld linker
 understands; when it sees a definition in another file for that symbol
 (matched just by the symbol name) it applies all the relocations of the
 symbol to the appropriate progbits.
I don't really see what else you could define 'extern' to mean.

> Partial verification should be available regardless of
> whether kernel performs dynamic linking or libbpf staticly links multiple .o
> together.
It's not clear to me how partial verification would work for statically
 linked programs — could you elaborate on this?

-Ed
