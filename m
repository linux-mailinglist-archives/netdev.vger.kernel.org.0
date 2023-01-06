Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19096601E2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjAFOP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjAFOPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:15:20 -0500
Received: from 2.mo619.mail-out.ovh.net (2.mo619.mail-out.ovh.net [178.33.254.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFF177D2D
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:15:18 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.108.4.137])
        by mo619.mail-out.ovh.net (Postfix) with ESMTPS id E39B22288D;
        Fri,  6 Jan 2023 14:15:14 +0000 (UTC)
Received: from [192.168.1.125] (37.65.8.229) by DAG10EX1.indiv4.local
 (172.16.2.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.16; Fri, 6 Jan
 2023 15:15:12 +0100
Message-ID: <cf6f7e30-9b0e-497b-87d4-df450949cd32@naccy.de>
Date:   Fri, 6 Jan 2023 15:15:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v3 00/16] bpfilter
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@meta.com>, <fw@strlen.de>
References: <20221224000402.476079-1-qde@naccy.de>
 <20221227182242.ozkc6u2lbwneoi4r@macbook-pro-6.dhcp.thefacebook.com>
Content-Language: fr
From:   Quentin Deslandes <qde@naccy.de>
In-Reply-To: <20221227182242.ozkc6u2lbwneoi4r@macbook-pro-6.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS11.indiv4.local (172.16.1.11) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 3239214032702926553
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdeivdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculdduhedmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthekredttdefjeenucfhrhhomhepsfhuvghnthhinhcuffgvshhlrghnuggvshcuoehquggvsehnrggttgihrdguvgeqnecuggftrfgrthhtvghrnhephfeuieffudeutdfgkeelffehtefhueeuudegteeghfetgfeutdejhfefhfdtgedtnecuffhomhgrihhnpegsrhgvrghkphhoihhnthdrtggtnecukfhppeduvdejrddtrddtrddupdefjedrieehrdekrddvvdelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoqhguvgesnhgrtggthidruggvqedpnhgspghrtghpthhtohepuddprhgtphhtthhopegrlhgvgigvihdrshhtrghrohhvohhithhovhesghhmrghilhdrtghomhdpnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrh
 hupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrgeskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdpuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhjohhlshgrsehkvghrnhgvlhdrohhrghdpfhifsehsthhrlhgvnhdruggvpdfovfetjfhoshhtpehmoheiudelpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/12/2022 à 19:22, Alexei Starovoitov a écrit :
> On Sat, Dec 24, 2022 at 01:03:46AM +0100, Quentin Deslandes wrote:
>>
>> Due to poor hardware availability on my side, I've not been able to
>> benchmark those changes. I plan to get some numbers for the next iteration.
> 
> Yeah. Performance numbers would be my main question :)

Hardware is on the way! :)

>> FORWARD filter chain is now supported, however, it's attached to
>> TC INGRESS along with INPUT filter chain. This is due to XDP not supporting
>> multiple programs to be attached. I could generate a single program
>> out of both INPUT and FORWARD chains, but that would prevent another
>> BPF program to be attached to the interface anyway. If a solution
>> exists to attach both those programs to XDP while allowing for other
>> programs to be attached, it requires more investigation. In the meantime,
>> INPUT and FORWARD filtering is supported using TC.
> 
> I think we can ignore XDP chaining for now assuming that Daniel's bpf_link-tc work
> will be applicable to XDP as well, so we'll have a simple chaining
> for XDP eventually.
> 
> As far as attaching to TC... I think it would be great to combine bpfilter
> codegen and attach to Florian's bpf hooks exactly at netfilter.
> See
> https://git.breakpoint.cc/cgit/fw/nf-next.git/commit/?h=nf_hook_jit_bpf_29&id=0c1ec06503cb8a142d3ad9f760b72d94ea0091fa
> With nf_hook_ingress() calling either into classic iptable or into bpf_prog_run_nf
> which is either generated by Florian's optimizer of nf chains or into
> bpfilter generated code would be ideal.

That sounds interesting. If my understanding is correct, Florian's
work doesn't yet allow for userspace-generated programs to be attached,
which will be required for bpfilter.
