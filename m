Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A7D2F4875
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbhAMKQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:16:57 -0500
Received: from foss.arm.com ([217.140.110.172]:33676 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbhAMKQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 05:16:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BE7D1042;
        Wed, 13 Jan 2021 02:16:10 -0800 (PST)
Received: from e107158-lin (e107158-lin.cambridge.arm.com [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36A343F66E;
        Wed, 13 Jan 2021 02:16:09 -0800 (PST)
Date:   Wed, 13 Jan 2021 10:16:06 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] trace: bpf: Allow bpf to attach to bare
 tracepoints
Message-ID: <20210113101606.lpsn4scnsecdfxwr@e107158-lin>
References: <20210111182027.1448538-1-qais.yousef@arm.com>
 <20210111182027.1448538-2-qais.yousef@arm.com>
 <8ef6c8e8-c462-a780-b1ab-b7f2e4fa9836@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ef6c8e8-c462-a780-b1ab-b7f2e4fa9836@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/21 12:19, Yonghong Song wrote:
> I applied the patch to my local bpf-next repo, and got the following
> compilation error:

[...]

> 
> I dumped preprecessor result but after macro expansion, the code
> becomes really complex and I have not figured out why it failed.
> Do you know what is the possible reason?

Yeah I did a last minute fix to address a checkpatch.pl error and my
verification of the change wasn't good enough obviously.

If you're keen to try out I can send you a patch with the fix. I should send v2
by the weekend too.

Thanks for having a look.

Cheers

--
Qais Yousef
