Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC952164454
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgBSMdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:33:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:47544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgBSMdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 07:33:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 347DFC08C;
        Wed, 19 Feb 2020 12:33:02 +0000 (UTC)
Subject: Re: [PATCH bpf-next 0/6] bpftool: Allow to select sections and filter
 probes
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200218190224.22508-1-mrostecki@opensuse.org>
 <CAADnVQJm_tvMGjhHyVn66feA3rHLSXTdzqCCABu+9tKer89LVA@mail.gmail.com>
From:   Michal Rostecki <mrostecki@opensuse.org>
Autocrypt: addr=mrostecki@opensuse.org; keydata=
 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
 ZURUUA==
Message-ID: <06ae3070-0d35-df49-9310-d1fb7bfb3e67@opensuse.org>
Date:   Wed, 19 Feb 2020 13:33:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJm_tvMGjhHyVn66feA3rHLSXTdzqCCABu+9tKer89LVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 4:02 AM, Alexei Starovoitov wrote:
> The motivation is clear, but I think the users shouldn't be made
> aware of such implementation details. I think instead of filter_in/out
> it's better to do 'full or safe' mode of probing.
> By default it can do all the probing that doesn't cause
> extra dmesgs and in 'full' mode it can probe everything.

Alright, then I will send later v2 where the "internal" implementation
(filtering out based on regex) stays similar (filter_out will stay in
the code without being exposed to users, filter_in will be removed). And
the exposed option of "safe" probing will just apply the
"(trace|write_user)" filter_out pattern. Does it sound good?
