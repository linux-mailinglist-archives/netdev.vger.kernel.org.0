Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF8660271
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjAFOoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjAFOnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:43:53 -0500
Received: from 7.mo545.mail-out.ovh.net (7.mo545.mail-out.ovh.net [46.105.63.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC88E5E651
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:43:51 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.111.172.143])
        by mo545.mail-out.ovh.net (Postfix) with ESMTPS id 943A22579B;
        Fri,  6 Jan 2023 14:43:48 +0000 (UTC)
Received: from [192.168.1.125] (37.65.8.229) by DAG10EX1.indiv4.local
 (172.16.2.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.16; Fri, 6 Jan
 2023 15:43:40 +0100
Message-ID: <8773f286-74ba-4efb-4a94-0c1f91d959bd@naccy.de>
Date:   Fri, 6 Jan 2023 15:43:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v3 00/16] bpfilter
Content-Language: fr
To:     Florian Westphal <fw@strlen.de>
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
        Kernel Team <kernel-team@meta.com>
References: <20221224000402.476079-1-qde@naccy.de>
 <20230103114540.GB13151@breakpoint.cc>
From:   Quentin Deslandes <qde@naccy.de>
In-Reply-To: <20230103114540.GB13151@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS11.indiv4.local (172.16.1.11) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 3721662146057268988
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdeikecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeegtefggeegtedtfeefkedvkeefleeiffeludetlefhkeffffejkefhgeeludeftdenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepfhifsehsthhrlhgvnhdruggvpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrgeskhgvrhhnvghlrdhorhhgpdgvughumhgrii
 gvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhjohhlshgrsehkvghrnhgvlhdrohhrghdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdfovfetjfhoshhtpehmohehgeehpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/01/2023 à 12:45, Florian Westphal a écrit :
> Quentin Deslandes <qde@naccy.de> wrote:
>> The patchset is based on the patches from David S. Miller [1],
>> Daniel Borkmann [2], and Dmitrii Banshchikov [3].
>>
>> Note: I've partially sent this patchset earlier due to a
>> mistake on my side, sorry for then noise.
>>
>> The main goal of the patchset is to prepare bpfilter for
>> iptables' configuration blob parsing and code generation.
>>
>> The patchset introduces data structures and code for matches,
>> targets, rules and tables. Beside that the code generation
>> is introduced.
>>
>> The first version of the code generation supports only "inline"
>> mode - all chains and their rules emit instructions in linear
>> approach.
>>
>> Things that are not implemented yet:
>>    1) The process of switching from the previous BPF programs to the
>>       new set isn't atomic.
> 
> You can't make this atomic from userspace perspective, the
> get/setsockopt API of iptables uses a read-modify-write model.

This refers to updating the programs from bpfilter's side. It won't
be atomic from iptables point of view, but currently bpfilter will
remove the program associated to a table, before installing the new
one. This means packets received in between those operations are
not filtered. I assume a better solution is possible.

> Tentatively I'd try to extend libnftnl and generate bpf code there,
> since its used by both iptables(-nft) and nftables we'd automatically
> get support for both.

That's one of the option, this could also remain in the kernel
tree or in a dedicated git repository. I don't know which one would
be the best, I'm open to suggestions.

> I was planning to look into "attach bpf progs to raw netfilter hooks"
> in Q1 2023, once the initial nf-bpf-codegen is merged.

Is there any plan to support non raw hooks? That's mainly out
of curiosity, I don't even know whether that would be a good thing
or not.
