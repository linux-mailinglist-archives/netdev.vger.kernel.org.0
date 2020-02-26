Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF63C16FEC3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 13:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgBZMRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 07:17:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:35856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbgBZMRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 07:17:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 66047ACE8;
        Wed, 26 Feb 2020 12:17:11 +0000 (UTC)
Subject: Re: [PATCH bpf-next v3 0/5] bpftool: Make probes which emit dmesg
 warnings optional
To:     Quentin Monnet <quentin@isovalent.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20200225194446.20651-1-mrostecki@opensuse.org>
 <e4929660-21ff-e394-37a0-d72b67a3770a@isovalent.com>
From:   Michal Rostecki <mrostecki@opensuse.org>
Autocrypt: addr=mrostecki@opensuse.org; keydata=
 mQINBF4whosBEADQd45MN9lBl17sx48EAAfyrc6sVtmf/qyqsQgpJnuLGQTbSdI2Nckz0w04
 YbGCGI0giMkBgJTEDB8+Or+DZtaa4MmnqMuivI9wWMJzf3IidAZOe262/blNjsTqITzoCJ48
 MLufgrv3XkEZPEaeOEEswZ/PaemQIgW3Jn1K6IYfg9mXA1+Sn42Ikj7c41r30pnCTVDlhcyS
 kMtt5Gs1u9yOkc8LFEo4w3F02SfFJ4t1ar04xY+znRwSDZh4xFVyradaP37mTDL/cAj94jEi
 44YzL22x6fAVRwH3wYLw49YnBK3j1uvys+DPqaOFJnQwfH3AA++tmOFYnJkC1s+E4mpcSIsn
 H/jRznlv7SPttTRfsaJL0Gk9tHaIUI4o1kLkfMOV0QDJ4xBOCeOfjBQwcDAeiVQXtMnx4XkB
 tmifSwFGlOTsEa0Mti7TlWrAPWBF5xEnG5tCuKaaLnyb4vu+gbV3r0TgI+BNv3ii+2nMFYWd
 u49pV23pck61oJ43hR1WOZUWIyLvTTQveaYRzbfcG7wbR/C2NIuAtEf8wxBv1aRI/vDCZSjV
 TK8Zh1pBdk+UsgC310ny4hcVYR1uwapJts2A+Q/rUMlsC6CAJwD916zAIAhaeNLOPYmb46Mw
 96AhRclvV5TW929X/vCe1iczDdfSyYkU41RJGTUSBfSQXMVomQARAQABtChNaWNoYWwgUm9z
 dGVja2kgPG1yb3N0ZWNraUBvcGVuc3VzZS5vcmc+iQJUBBMBCAA+FiEE/xPU917HlqMFVtFM
 7/hds1JJaVUFAl4whosCGwMFCQHgwSUFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQ7/hd
 s1JJaVWoyRAApCxV1shTrcIwO8ejZwr0NeZ2EBODcbJULgtjZCaCZp8ABzzUAB8uZCmxCDdL
 PEDlZgWW8Pm0SkS5jyJZ4AI1OQNtX6m/gy7fFCpr1MIZoHsVuzYHswxzZhcDGbTXrkcmLygD
 dTikyLEKAeCGMU6pbGrHfhzIRGasII1PqSO43XZYEKGPC3YgEIyx/tuL8bX3z/TxPp52oOjp
 Q3bmJEIWEzz5v/46WE4Dj3s0aKTDY6zBoYGRehSuqaBRVEIR7Y7HBMtcPwK5S1VflG38B5wh
 QuwRlz7Uuy48o0vsdnSMjuJoPZ4tmg056d0cmSse2NBfN+FPVrEw1L84jdijCBqLRam6tXuU
 4Npszr2Z6/OBu6gkn9FqSNP8nLwnvnEJ5300epRZ4kzJgtUhMz0743fE21bzNxJB4xdMcOjV
 /yucMfwbgp3dD84A3N8jPaWCsLNuRsxjoAk6OKFz+WtHxT8m8ValYI4sn9PRhzTDTtnGlC/P
 Sem/CIseMXNYxT6mJsXkjZi757/RM3JabNZ/N0gMiquVYAapxrxv2qiMDPHByZZd+yOsBk4X
 FgfWwhOwW5g2qxXZ2mtMD4gAcDLj6x4QVf6mf6k4nPWgnOyZG7yrxu96R4jKN+kO6UAQ3RC+
 FnCxz92QefeV0rYtF+DWy/5GElQowD+wVxZDUJgwki4SjVO5Ag0EXjCGiwEQAMSNQ0O2g4no
 bi5T/eOhfVN6dzwr5nestMluQy4Xab1D2+vv4WcoIcxxj48pMSicNgbzHtoFKOALQEptuKwE
 tipiOchCtCi6atpFC0hiy+eogaxC6sysvJ0MwBWk0spWXsPQRxIy/zWQaG0NLRNXOYhupgxZ
 TN3008FsriFu/V0mQnF58w+Y8ZbpfaFUEJn4KoYtJEsjezYIAdQUDtohSrUzeK7KHGeBuePf
 XyIsZZKRaMoYbAguE3WDLcqWPBLGH0ra5O+IkqoStc6FpyyvoNLAHTtJNfYfbpXpBjrl/x2n
 hQqohQrH7+t8lDe4B6EPSHdSV9qY5l0p0y17nXY3ghQs/hqH6aw6MB52KtydKs/3dl9rxW61
 6McUUQGy6Z0H2MnV1KqiLvNx5abfOcbUGMZPwHYqPU4zoOQhbWN34q2AuK4lEY5nbmgwI92m
 PFE5S5A2YPi2pFzVxhWUWFfX1AHWQ2NMudiYljFgCsp9sJLI+UCb8fNyDWD72e5QqKzBSLf/
 z94NICpqBGX9Z4+uF0dmPZlJTilgFU3jEUuth5NiTm1qQBUqAHUAgZhGIqVWpECHFKaIMUxv
 Xj6bvOCrCR0PfWxalS3RJT7z4OsETAG7QT4yOlqOhP5uue3I6WnzaQPZU0Gp9+vyQpuCVPdl
 HbK2kx9hg5imRgmZLOKyjdhbABEBAAGJAjwEGAEIACYWIQT/E9T3XseWowVW0Uzv+F2zUklp
 VQUCXjCGiwIbDAUJAeDBJQAKCRDv+F2zUklpVaFiEACHVCJJPXenIc5C4zkuu1pn0dmouoZV
 LWEyk3zjcC7wVJ/RGr4apLKU0hAfp9O12/s4mxa3lzZ9EvaWUY7NwwYx4kCmVcsq2+a6NVNI
 nkKUqPvj8sXd9dHWk283hDwrQrL7QPysr767TrLcXQ2l8o19q02lN/D7Jte37td8JMrsErEF
 B0Q31D+HWnn1rFJCeCn5/vwHgDW8wWtYYisv/EmUf7ppP9teiNtrQinyljTUMsb1hiy2HkhL
 qEOR7Q/NVk1yDC+oyQ08Zvt9LkELo3fPoeXX8RlbCUA36zq+3HsHggI6XJNmYDSS+l7N5r9B
 GEGFgLvCFJMP6nNX16nkvpYflxIzlmAAWQUR8K/VGvW8YgfRJBVw7+AhCe7mXubIbTa9IrJs
 QR74gvfGuJWrWq0ZtOzS5cKxos0rF2VON2rig5+5lf9A1UP1ZH0nfVCx5iXuJ1O1ld6tXHpD
 qRunpTuuKg3wkHCAS4oC/ECFHV8JukpgEuR7CNvBbYyjc7BFImmOe0bGbbntFnU173ehj0A0
 hjrs3VY5x7TDedJwEr5iMKzvI4NlXNQEjDEltBN88gMvtFo6w8W/bbe6OalIEfs42DS+5KIg
 X91a5VRZRQo853ef/YjTRCZkGhUJ9A5uCLodR14o+C2Lzc3EmJ89awrqiAirZWPuZHCfud+f
 ZURUUA==
Message-ID: <0e46d001-a137-97bc-262c-e864cf3f90b8@opensuse.org>
Date:   Wed, 26 Feb 2020 13:17:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e4929660-21ff-e394-37a0-d72b67a3770a@isovalent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 12:17 PM, Quentin Monnet wrote:
> 2020-02-25 20:44 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
>> Feature probes in bpftool related to bpf_probe_write_user and
>> bpf_trace_printk helpers emit dmesg warnings which might be confusing
>> for people running bpftool on production environments. This patch series
>> addresses that by filtering them out by default and introducing the new
>> positional argument "full" which enables all available probes.
>>
>> The main motivation behind those changes is ability the fact that some
>> probes (for example those related to "trace" or "write_user" helpers)
>> emit dmesg messages which might be confusing for people who are running
>> on production environments. For details see the Cilium issue[0].
>>
>> v1 -> v2:
>> - Do not expose regex filters to users, keep filtering logic internal,
>> expose only the "full" option for including probes which emit dmesg
>> warnings.
>>
>> v2 -> v3:
>> - Do not use regex for filtering out probes, use function IDs directly.
>> - Fix bash completion - in v2 only "prefix" was proposed after "macros",
>>    "dev" and "kernel" were not.
>> - Rephrase the man page paragraph, highlight helper function names.
>> - Remove tests which parse the plain output of bpftool (except the
>>    header/macros test), focus on testing JSON output instead.
>> - Add test which compares the output with and without "full" option.
>>
>> [0] https://github.com/cilium/cilium/issues/10048
>>
>> Michal Rostecki (5):
>>    bpftool: Move out sections to separate functions
>>    bpftool: Make probes which emit dmesg warnings optional
>>    bpftool: Update documentation of "bpftool feature" command
>>    bpftool: Update bash completion for "bpftool feature" command
>>    selftests/bpf: Add test for "bpftool feature" command
>>
>>   .../bpftool/Documentation/bpftool-feature.rst |  19 +-
>>   tools/bpf/bpftool/bash-completion/bpftool     |   3 +-
>>   tools/bpf/bpftool/feature.c                   | 283 +++++++++++-------
>>   tools/testing/selftests/.gitignore            |   5 +-
>>   tools/testing/selftests/bpf/Makefile          |   3 +-
>>   tools/testing/selftests/bpf/test_bpftool.py   | 179 +++++++++++
>>   tools/testing/selftests/bpf/test_bpftool.sh   |   5 +
>>   7 files changed, 374 insertions(+), 123 deletions(-)
>>   create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
>>   create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh
>>
> 
> This version looks good to me, thanks!
> 
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> 
> (Please keep Acked-by/Reviewed-by tags between versions if there are no
> significant changes, here for patch 1.)

Sorry, I will do that next time.

> That's a lot of tests now that we don't have the regex and filtering is
> very straightforward, but it does not hurt. I checked and they all pass
> on my system.

I know that those tests were necessary with the regex implementation and
now they may seem to be an overkill. But on the other hand, I think that
having selftests for bpftool in general is a good thing, so I didn't
want throw them away despite the easier implementation of my patches. I
might follow up with some more tests covering the other subcommands in
future.

Cheers,
Michal
