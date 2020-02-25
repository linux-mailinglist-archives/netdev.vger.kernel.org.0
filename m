Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C340016C2CE
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgBYNzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:55:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:49614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbgBYNzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 08:55:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F7DBAC5C;
        Tue, 25 Feb 2020 13:55:13 +0000 (UTC)
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: Add test for "bpftool
 feature" command
To:     Quentin Monnet <quentin@isovalent.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
 <20200221031702.25292-6-mrostecki@opensuse.org>
 <d178dc6c-7696-8e58-9df9-887152104a1c@isovalent.com>
From:   Michal Rostecki <mrostecki@opensuse.org>
Autocrypt: addr=mrostecki@opensuse.org; keydata=
 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
 ZURUUA==
Message-ID: <c24d2b7a-889b-9294-cd30-6938f00b645a@opensuse.org>
Date:   Tue, 25 Feb 2020 14:55:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d178dc6c-7696-8e58-9df9-887152104a1c@isovalent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/20 12:28 PM, Quentin Monnet wrote:
>> +    @default_iface
>> +    def test_feature_dev(self, iface):
>> +        expected_patterns = [
>> +            SECTION_SYSCALL_CONFIG_PATTERN,
>> +            SECTION_PROGRAM_TYPES_PATTERN,
>> +            SECTION_MAP_TYPES_PATTERN,
>> +            SECTION_HELPERS_PATTERN,
>> +            SECTION_MISC_PATTERN,
>> +        ]
> 
> Mixed feeling on the tests with plain output, as we keep telling people
> that plain output should not be parsed (not reliable, may change). But
> if you want to run one or two tests with it, why not, I guess.

I thought about that and yes, testing the plain output is probably
redundant and makes those tests less readable. However, the only plain
output test which I would like to keep there is test_feature_macros -
because I guess that we are not planning to change names or patterns of
generated macros (or if so, we should test that change).
