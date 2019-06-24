Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2584FF02
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfFXCFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 22:05:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:38790 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfFXCFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 22:05:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jun 2019 17:43:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,410,1557212400"; 
   d="scan'208";a="151793277"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.6]) ([10.239.13.6])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2019 17:43:19 -0700
Subject: Re: 6c409a3aee: kernel_selftests.bpf.test_verifier.fail
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andreas Steinmetz <ast@domdv.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Edward Cree <ecree@solarflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>, LKP <lkp@01.org>
References: <20190618214028.y2qzbtonozr5cc7a@ast-mbp.dhcp.thefacebook.com>
 <20190621083658.GT7221@shao2-debian>
 <CAADnVQ+frnYN6E5zyrNvbnhQ_XgvrEEtghiS7DOKoe6o_ErYRw@mail.gmail.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <6113e667-fd7c-decc-7d3f-893d7a3f000e@intel.com>
Date:   Mon, 24 Jun 2019 08:43:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+frnYN6E5zyrNvbnhQ_XgvrEEtghiS7DOKoe6o_ErYRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/19 11:52 PM, Alexei Starovoitov wrote:
> On Fri, Jun 21, 2019 at 1:36 AM kernel test robot <rong.a.chen@intel.com> wrote:
>> # #340/p direct packet access: test22 (x += pkt_ptr, 3) OK
>> # #341/p direct packet access: test23 (x += pkt_ptr, 4) FAIL
>> # Unexpected success to load!
>> # verification time 17 usec
>> # stack depth 8
>> # processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
>> # #342/p direct packet access: test24 (x += pkt_ptr, 5) OK
>> # #343/p direct packet access: test25 (marking on <, good access) OK
> ..
>> # #673/p meta access, test9 OK
>> # #674/p meta access, test10 FAIL
>> # Unexpected success to load!
>> # verification time 29 usec
>> # stack depth 8
>> # processed 19 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
>> # #675/p meta access, test11 OK
> Hi Rong,
>
> the patch quoted is not in bpf-next/net-next.
> This patch is work-in-progress that I posted to mailing list
> and pushed into my own git branch on kernel.org.
> It's awesome that build bot does this early testing.
> I really like it.
> Would be great if the bot can add a tag to email subject that it's testing
> this not yet merged patch.
>
> Right now since the email says
> commit: 6c409a3aee945e50c6dd4109689f52
> it felt that this is real commit and my initial reaction
> was that 'ohh something is broken in the merge code'
> which wasn't the case :)


Hi Alexei,

Thanks for the advice, we'll improve the email subject.

Best Regards,
Rong Chen



