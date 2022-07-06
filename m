Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC683568EAA
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiGFQJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiGFQJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:09:29 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC6AC1C11B;
        Wed,  6 Jul 2022 09:09:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B18A1106F;
        Wed,  6 Jul 2022 09:09:28 -0700 (PDT)
Received: from myrica (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B19A63F66F;
        Wed,  6 Jul 2022 09:09:23 -0700 (PDT)
Date:   Wed, 6 Jul 2022 17:08:49 +0100
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Xu Kuohai <xukuohai@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <James.Morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
Message-ID: <YsWzfPUmgtRZi/ny@myrica>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <d3c1f1ed-353a-6af2-140d-c7051125d023@iogearbox.net>
 <20220705160045.GA1240@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705160045.GA1240@willie-the-truck>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 05:00:46PM +0100, Will Deacon wrote:
> > Given you've been taking a look and had objections in v5, would be great if
> you
> > can find some cycles for this v6.
> 
> Mark's out at the moment, so I wouldn't hold this series up pending his ack.
> However, I agree that it would be good if _somebody_ from the Arm side can
> give it the once over, so I've added Jean-Philippe to cc in case he has time
> for a quick review.

I'll take a look. Sorry for not catching this earlier, all versions of the
series somehow ended up in my spams :/

Thanks,
Jean

> KP said he would also have a look, as he is interested
> in this series landing.
> 
> Failing that, I'll try to look this week, but I'm off next week and I don't
> want this to miss the merge window on my account.
> 
> Cheers,
> 
> Will
