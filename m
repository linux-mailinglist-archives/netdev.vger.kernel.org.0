Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80276167C0F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgBUL2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:28:52 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52872 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgBUL2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:28:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so1385074wmc.2
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 03:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nIJB+5DpBUi88nWZ4SVTkykQyY+2jcMAkIig0VNlc6s=;
        b=qTwp+puXQqiQC54kHUq1ahH6bfGourCCayrCIrqHRMv7jdsHXMmnrwnACDjwACGKR7
         M7YK9kbzwhDVODTLHKPLBKeDcwCayYPWkAFX5F4SQAUeyGP2GmCRL5wxyHm5t/pcKlNv
         tBRAfbE1166baDd8iM/yGQM7yiZwGX52A3diiF7R8y2HCbk2olaMg4QTrYUw14FWQ/Dn
         kBq/bpvJRdFesm2sMd2va3fdgWG8Uu3uEgafha3XfWeOw1pAxrj7T5lgCBFpmCtnba8m
         tlY3qF48lTvUdIWxYflGK1ULzpmYJF1dLyscM/y4nc4ExmKz5FBWwUmqzQtVoXPrLJK9
         NsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIJB+5DpBUi88nWZ4SVTkykQyY+2jcMAkIig0VNlc6s=;
        b=QnSpSFL0mAF6SviTXc9ZqMx//PZCUjSSsBIbEEBqkvAwj0mLhWjV+YYgmDo65akBza
         +NOkn0QWxtVgXEEhY0O5pFldIeZGB9q4PImwOIigk6SBdrFi3AFew7QMQx48q0EgdHfy
         h/7vL0ITL0TZhy/cdUKm+SZJWpP6p+zZ2LeE6gswlkrPNz6hKWBdWBsuP82V8CGQbg8P
         RqSwaQWHtO6/UOEFzVQpIqdEN2K9x8SeiB0OXewFHHl6C0ak6W+jJHKvxTkHr1ROpT4Y
         vnHOvjtbZP5Fi7v2v9W3F5EXvQ3hjV68p49BUvXIHHR04BxZIn9mgzk+t1YbuO4Jt0oT
         QQUQ==
X-Gm-Message-State: APjAAAUoS+n8p66Dn+9Wa7MY/OFAZz80PlwAAkwOQbdhHHMkZXprVFoL
        enlKUcsNiPN6GfVIA3xdq8VuWw==
X-Google-Smtp-Source: APXvYqwfUTqCjr/7H7whH56UlENRZJMz5zurvouE7WaITAABdxQphGipuCaJFyXJ6P/EyPMUbVtsew==
X-Received: by 2002:a7b:c216:: with SMTP id x22mr3343710wmi.51.1582284529590;
        Fri, 21 Feb 2020 03:28:49 -0800 (PST)
Received: from [192.168.1.23] ([91.143.66.155])
        by smtp.gmail.com with ESMTPSA id g15sm3646544wro.65.2020.02.21.03.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 03:28:48 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: Add test for "bpftool
 feature" command
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
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
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <d178dc6c-7696-8e58-9df9-887152104a1c@isovalent.com>
Date:   Fri, 21 Feb 2020 11:28:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221031702.25292-6-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-21 04:17 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> Add Python module with tests for "bpftool feature" command, which mainly
> wheck whether the "full" option is working properly.
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>   tools/testing/selftests/.gitignore          |   5 +-
>   tools/testing/selftests/bpf/Makefile        |   3 +-
>   tools/testing/selftests/bpf/test_bpftool.py | 228 ++++++++++++++++++++
>   tools/testing/selftests/bpf/test_bpftool.sh |   5 +
>   4 files changed, 239 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
>   create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh
> 
> diff --git a/tools/testing/selftests/.gitignore b/tools/testing/selftests/.gitignore
> index 61df01cdf0b2..304fdf1a21dc 100644
> --- a/tools/testing/selftests/.gitignore
> +++ b/tools/testing/selftests/.gitignore
> @@ -3,4 +3,7 @@ gpiogpio-hammer
>   gpioinclude/
>   gpiolsgpio
>   tpm2/SpaceTest.log
> -tpm2/*.pyc
> +
> +# Python bytecode and cache
> +__pycache__/
> +*.py[cod]
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 257a1aaaa37d..e7d822259c50 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -62,7 +62,8 @@ TEST_PROGS := test_kmod.sh \
>   	test_tc_tunnel.sh \
>   	test_tc_edt.sh \
>   	test_xdping.sh \
> -	test_bpftool_build.sh
> +	test_bpftool_build.sh \
> +	test_bpftool.sh
>   
>   TEST_PROGS_EXTENDED := with_addr.sh \
>   	with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/test_bpftool.py b/tools/testing/selftests/bpf/test_bpftool.py
> new file mode 100644
> index 000000000000..7f545feaec98
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_bpftool.py
> @@ -0,0 +1,228 @@
> +# Copyright (c) 2020 SUSE LLC.
> +#
> +# This software is licensed under the GNU General License Version 2,
> +# June 1991 as shown in the file COPYING in the top-level directory of this
> +# source tree.
> +#
> +# THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS"
> +# WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
> +# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> +# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
> +# OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME
> +# THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

SPDX tag instead of boilerplate?

> +
> +import collections
> +import functools
> +import json
> +import os
> +import socket
> +import subprocess
> +import unittest
> +
> +
> +# Add the source tree of bpftool and /usr/local/sbin to PATH
> +cur_dir = os.path.dirname(os.path.realpath(__file__))
> +bpftool_dir = os.path.abspath(os.path.join(cur_dir, "..", "..", "..", "..",
> +                                           "tools", "bpf", "bpftool"))
> +os.environ["PATH"] = bpftool_dir + ":/usr/local/sbin:" + os.environ["PATH"]
> +
> +# Probe sections
> +SECTION_SYSTEM_CONFIG_PATTERN = b"Scanning system configuration..."
> +SECTION_SYSCALL_CONFIG_PATTERN = b"Scanning system call availability..."
> +SECTION_PROGRAM_TYPES_PATTERN = b"Scanning eBPF program types..."
> +SECTION_MAP_TYPES_PATTERN = b"Scanning eBPF map types..."
> +SECTION_HELPERS_PATTERN = b"Scanning eBPF helper functions..."
> +SECTION_MISC_PATTERN = b"Scanning miscellaneous eBPF features..."
> +
> +
> +class IfaceNotFoundError(Exception):
> +    pass
> +
> +
> +class UnprivilegedUserError(Exception):
> +    pass
> +
> +
> +def _bpftool(args, json=True):
> +    _args = ["bpftool"]
> +    if json:
> +        _args.append("-j")
> +    _args.extend(args)
> +
> +    res = subprocess.run(_args, capture_output=True)
> +    return res.stdout
> +
> +
> +def bpftool(args):
> +    return _bpftool(args, json=False)
> +
> +
> +def bpftool_json(args):
> +    res = _bpftool(args)
> +    return json.loads(res)
> +
> +
> +def get_default_iface():
> +    for iface in socket.if_nameindex():
> +        if iface[1] != "lo":
> +            return iface[1]
> +    raise IfaceNotFoundError("Could not find any network interface to probe")
> +
> +
> +def default_iface(f):
> +    @functools.wraps(f)
> +    def wrapper(*args, **kwargs):
> +        iface = get_default_iface()
> +        return f(*args, iface, **kwargs)
> +    return wrapper
> +
> +
> +class TestBpftool(unittest.TestCase):
> +    @classmethod
> +    def setUpClass(cls):
> +        if os.getuid() != 0:
> +            raise UnprivilegedUserError("This test suite eeeds root privileges")

Typo: eeeds

> +
> +    def _assert_pattern_not_in_dict(self, dct, pattern, check_keys=False):
> +        """Check if all string values inside dictionary do not containe the

Typo: containe

> +        given pattern.
> +        """
> +        for key, value in dct.items():
> +            if check_keys:
> +                self.assertNotIn(pattern, key)
> +            if isinstance(value, dict):
> +                self._assert_pattern_not_in_dict(value, pattern,
> +                                                 check_keys=True)
> +            elif isinstance(value, str):
> +                self.assertNotIn(pattern, value)
> +
> +    @default_iface
> +    def test_feature_dev(self, iface):
> +        expected_patterns = [
> +            SECTION_SYSCALL_CONFIG_PATTERN,
> +            SECTION_PROGRAM_TYPES_PATTERN,
> +            SECTION_MAP_TYPES_PATTERN,
> +            SECTION_HELPERS_PATTERN,
> +            SECTION_MISC_PATTERN,
> +        ]

Mixed feeling on the tests with plain output, as we keep telling people 
that plain output should not be parsed (not reliable, may change). But 
if you want to run one or two tests with it, why not, I guess.

> +        unexpected_patterns = [
> +            b"bpf_trace_printk",
> +            b"bpf_probe_write_user",
> +        ]
> +
> +        res = bpftool(["feature", "probe", "dev", iface])
> +        for pattern in expected_patterns:
> +            self.assertIn(pattern, res)
> +        for pattern in unexpected_patterns:
> +            self.assertNotIn(pattern, res)
> +
> +    @default_iface
> +    def test_feature_dev_json(self, iface):
> +        expected_keys = [
> +            "syscall_config",
> +            "program_types",
> +            "map_types",
> +            "helpers",
> +            "misc",
> +        ]
> +        unexpected_values = [
> +            "bpf_trace_printk",
> +            "bpf_probe_write_user",
> +        ]
> +
> +        res = bpftool_json(["feature", "probe", "dev", iface])
> +        self.assertCountEqual(res.keys(), expected_keys)
> +        for value in unexpected_values:
> +            self._assert_pattern_not_in_dict(res, value)
> +
> +    def test_feature_kernel(self):
> +        expected_patterns = [
> +            SECTION_SYSTEM_CONFIG_PATTERN,
> +            SECTION_SYSCALL_CONFIG_PATTERN,
> +            SECTION_PROGRAM_TYPES_PATTERN,
> +            SECTION_MAP_TYPES_PATTERN,
> +            SECTION_HELPERS_PATTERN,
> +            SECTION_MISC_PATTERN,
> +        ]
> +        unexpected_patterns = [
> +            b"bpf_trace_printk",
> +            b"bpf_probe_write_user",
> +        ]
> +
> +        res_default1 = bpftool(["feature"])
> +        res_default2 = bpftool(["feature", "probe"])
> +        res = bpftool(["feature", "probe", "kernel"])
> +
> +        for pattern in expected_patterns:
> +            self.assertIn(pattern, res_default1)
> +            self.assertIn(pattern, res_default2)
> +            self.assertIn(pattern, res)
> +        for pattern in unexpected_patterns:
> +            self.assertNotIn(pattern, res_default1)
> +            self.assertNotIn(pattern, res_default2)
> +            self.assertNotIn(pattern, res)
> +
> +    def test_feature_kernel_full(self):
> +        expected_patterns = [
> +            SECTION_SYSTEM_CONFIG_PATTERN,
> +            SECTION_SYSCALL_CONFIG_PATTERN,
> +            SECTION_PROGRAM_TYPES_PATTERN,
> +            SECTION_MAP_TYPES_PATTERN,
> +            SECTION_HELPERS_PATTERN,
> +            SECTION_MISC_PATTERN,
> +            b"bpf_trace_printk",
> +            b"bpf_probe_write_user",
> +        ]

However, if you do just one test for "kernel full", please favour JSON 
over plain output.

> +
> +        res_default = bpftool(["feature", "probe", "full"])
> +        res = bpftool(["feature", "probe", "kernel", "full"])
> +
> +        for pattern in expected_patterns:
> +            self.assertIn(pattern, res_default)
> +            self.assertIn(pattern, res)
> +
> +    def test_feature_kernel_json(self):
> +        expected_keys = [
> +            "system_config",
> +            "syscall_config",
> +            "program_types",
> +            "map_types",
> +            "helpers",
> +            "misc",
> +        ]
> +        unexpected_values = [
> +            "bpf_trace_printk",
> +            "bpf_probe_write_user",
> +        ]
> +
> +        res_default1 = bpftool_json(["feature"])
> +        self.assertCountEqual(res_default1.keys(), expected_keys)
> +        for value in unexpected_values:
> +            self._assert_pattern_not_in_dict(res_default1, value)
> +
> +        res_default2 = bpftool_json(["feature", "probe"])
> +        self.assertCountEqual(res_default2.keys(), expected_keys)
> +        for value in unexpected_values:
> +            self._assert_pattern_not_in_dict(res_default2, value)
> +
> +        res = bpftool_json(["feature", "probe", "kernel"])
> +        self.assertCountEqual(res.keys(), expected_keys)
> +        for value in unexpected_values:
> +            self._assert_pattern_not_in_dict(res, value)
> +
> +    def test_feature_macros(self):
> +        expected_patterns = [
> +            b"/\*\*\* System call availability \*\*\*/",
> +            b"#define HAVE_BPF_SYSCALL",
> +            b"/\*\*\* eBPF program types \*\*\*/",
> +            b"#define HAVE.*PROG_TYPE",
> +            b"/\*\*\* eBPF map types \*\*\*/",
> +            b"#define HAVE.*MAP_TYPE",
> +            b"/\*\*\* eBPF helper functions \*\*\*/",
> +            b"#define HAVE.*HELPER",
> +            b"/\*\*\* eBPF misc features \*\*\*/",
> +        ]
> +
> +        res = bpftool(["feature", "probe", "macros"])
> +        for pattern in expected_patterns:
> +            self.assertRegex(res, pattern)

Could we have (or did I miss it?) a test that compares the output of 
probes _with_ "full" and _without_ it, to make sure that the only lines 
that differ are about "bpf_trace_prink" or "bpf_probe_write_user"? Could 
help determine if we filter out too many elements by mistake.

Thanks,
Quentin

> diff --git a/tools/testing/selftests/bpf/test_bpftool.sh b/tools/testing/selftests/bpf/test_bpftool.sh
> new file mode 100755
> index 000000000000..66690778e36d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_bpftool.sh
> @@ -0,0 +1,5 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 SUSE LLC.
> +
> +python3 -m unittest -v test_bpftool.TestBpftool
> 

