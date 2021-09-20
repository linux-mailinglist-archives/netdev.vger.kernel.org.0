Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6C4129A3
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 01:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbhIUAAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 20:00:07 -0400
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:44262
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234673AbhITX6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 19:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632182198; bh=q/+1FTR6kdByQ3fktcKlOWvcmDsBmPI6Yn4r1obazFQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=G2SeTXMSowMSfC9uocdrN9eC1stgRUZw1t1SZXk1+7CRHKhs2NBJ1XaToq9oN200sbA/NDhuEBBo2XOEQ9zkGbqZdJltqR2iiO+51aRDKK7+GVQ+5Gt1/HhpkCWVLE1iR0ILrOaIo2IHECbjUi2lvgoFaOHffyHghr0y2Jz9v9l/QFRquoGVvpjToccUhpoOuGZ27vnnFoiddHnXxVSzNJ0fwskO/cgu6fRNnac+4jOY4p63U9KXwDDJhj35efo1gG5Y4K6fkFQolimbdV4M27pf0CfbQUJ3YZcYOGUJ9a4s9q93bv9PygUPIIaGEvRE2gd+mAYrx0HgjqoKjr7XKA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632182198; bh=ldq14wcJmwkpJ2I9dyTCsfWbbcx5OFEpI6P4IYL6vsb=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=EqPHUjSNy4Sje1O+AHDc3g4NGE63EkETPCrUYv0lkTTd5pXPQZw+i8q8gU3ASRTXSXBc0zKziNRDXuxx6yyGI/5uNwsjy/Rx0ZWF0oKxEXYpkLqSH0xHZnTD4qK2aYocBqAn7lgA9pjxP0euLLVonOR+hge157ov/bj5wfKr41Tu2P0RIlnr8aOKqJiGq3aU8ufgt1bgOaPkr/kJHhVpvKyxtqigeGZw3fQ5qeuuN2jNL2QSDx8EwDdUEXjZ0c5TiTptQo8aivbQXrg0q6Hc/a4bDBGSsAFn+94RJWvoJhhRnkjZd5vhVZ0VC1JsaaFbMGY0OUMDu8zMFrJu8N8U0w==
X-YMail-OSG: 390Dmg8VM1lVbeev6GwFBCGxG_llrDKWHT2.hLDRJULiHL1zlMVZ3VY4sUZzJCf
 m9V7KFjZsWKvMlkf22gspeLiEUa3juLYUnAMoVxqyRUDMl498mzBYzjQv7q2519zeEn9dQU1FZvJ
 7ofhmaqZMae1oTCp.edwFErrieqXe7Ip8CNZZi4wSoif52nitrMF9sFNY4DjyqdIjN7EKxvcWyRT
 ZbGuah3u2CfzNbkUbFUAebRasYwjl5CR4bbDFkvm5OB1rWOjTLNfxZSzB6.1PG5gPif18PzilyRt
 jkne217GJ0d0vXRhTH_sZcghoEV7.6bU9ysmGmbVtOne5PezZC8mYcZmYxkgeQPjnyPD.mbJ_dAI
 ta0ZXXm7InvoFMs9XYKUHNkYSeEx6TwS_jZaMhHlSw2Fi7BTcqpGEb8c2meKk8XpLPpGtMNTUO09
 6PizQvD5p3IoLw9VAEZl7xI1wuGgLvyfa5ChgaVOoX.gCiPl6EffkHk4gIvB3Iz1a6bbAjWAz55C
 u46hfWVsGdbTo37zouAAcMt2pr_mpb0nN9rWvcfEVM9UyyLcDtxB51ntPtBt3WJHKeh3dSpvvzV7
 0Zwsm_894I8WOFUwUVsPil5zTHLYtQo6aBm9nfkVUXVYBRvP.gpmtZQDvNW83nOoCqsfewtwrbiD
 fnxR.K6oqJkUO3.I_teNkus7IfGxWbOMUmEk14DyPH_02b1E23K5zZNxNXvJ8X_O9MlSOrOvmpRN
 W0gpcJ291jZYbmW8dJIe1OpqFEVV2siDhARf4QI4_oXY0TmM7jlfKR_945IZoBKJF7aDlQJQzSPt
 KeT5At0Iv5N6Rn6f9917eH1SDOqUkWD.tdyirBQ9yplz2bdFpuQ8TVZnZ1awOzSd7yXWlogDosDV
 fL6MgdgxQVj1nw7U8pkUDEq1_31ZQzA1wbtwCkCKfywajPWC2cQpWp313Oc7KV0jHEDX608T.GLa
 rTLztU.lp76GnKWLNyGGhuGlRH1WCRiEbt8_Gn82ux2qmr9aeTnoMU7Y6uKn2vhQStf..qlz.NdG
 n0MKYjNz9ijjYzjCc5CrBNYZxWaX51h0xZG52IGFHxPhv2znmNBVZPzrfFCBcY2sSV5MrRBTWR9K
 vz7WbRGJ7RequVJCn.SBf7lKDK6V1KKUpgy3jy4pcD2FNL9Xn6mo3DNgZL8ZHuWH8bd8ty7TTAIz
 aqIH5aJH7TjqRsm11VgOosc_mnSRamfmVj9s8yom7r413peQAGM9D5xSrYI2rrEUXJvo8KUDsiGr
 rI9064fPyjVHOoGL6YkW39FQbpxOw5HTmXgoidq0XFkxBDxC08RlS1V53gyD0A50ISgdHpAq5sXs
 _5M4e64JNXH6U48fICLz6udfsS53cQasBS.phhFk47r8wxWHWMTuhTafTlYggVEY5xsfhf2JoATe
 iYdXuPQwbB8FP8EBrDQprlbng3KjTlzzoDoorOjo0AMzAVNBhFyqalSAyCNGidQVP_7GLgmR7MVb
 BJpQc_DIB.chKStmg81m1iHRd1Ukb5QWIIh1U4XFlVfEZ7jG0nkFgH1ialxpmnp42soXaF8XJY3n
 YNWG7ApQuPMbmwfR1M2db8QOASNBJgVvroonzW.VKFfL.Sg.MDjwlZcgIghpT8Y9PBEwPTva6FiQ
 Bz.01K.cUAj7qyhmn5h5zKz4x9qJR3cxnQ2IdRs9fRUL.JTVR9LKWm8ujVbrci4jB5JHSs7Uig2J
 wdvihC2wXr_JEfI85Ti53zi7qJEedad3xTUTlM6WeIF5jQnF4X0oyINHYdgG4qOOYw9slfLuOjZA
 T6oVyrhDWWtSAriRrp2iyT6QNlqcH27zCi6ctYpjWH8VjdjVhPSaCO8HRgFfS89ZUNwS2KF6blDk
 KKB_klpsFhUei91uro_WAL29w7nntMn_GiI95gPHKf6QeAtC6QXvNlm6CrKxP1N1pKVNmUg9bjDb
 dygshvyzHZPkgXLyb6cks1QFvnOIgbTO6wbZSi1GSHSsPnxhwlKW9yQHzHuhDc0l8MSZG.U_F2tr
 cKvfrwmx7glzNb_hdcjFuLJRQK4itn3jeIR62M9EpBCi3IxffE33P_f5r08_aLXB2eyovcBhECmK
 MuXmQiiYFdayn0u23rLl.dksTZFnoAfyka.7QSLdD.M8HtlFjpnx9Z5dGqBlS4M4zF9Dbxh95Nh1
 UcSL8l3__BHetcsOI.UDvYo8T_8lJJMwIvIQybY1jd8EMvC8OS6aKHpH.S_ueCC8_yJmTQjRXGxl
 NOcI9qrS4cGJa0XugewhUhfBJiRtwoXXCnRdTKiFt8yNeSQQrZ_9UgKDjSGjQ0gji3PiTzR6zdb5
 nV1QbMXmr7nYKMstiDhwZq1pAzJPHRT.WSWjRER0ZQOZbeHlb
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Mon, 20 Sep 2021 23:56:38 +0000
Received: by kubenode541.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 99664d0fb461305fcde124f7db83b93c;
          Mon, 20 Sep 2021 23:44:32 +0000 (UTC)
Subject: Re: Regression in unix stream sockets with the Smack LSM
To:     "Jiang Wang ." <jiang.wang@bytedance.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <a507efa7-066b-decf-8605-89cdb0ac1951.ref@schaufler-ca.com>
 <a507efa7-066b-decf-8605-89cdb0ac1951@schaufler-ca.com>
 <CAHC9VhR9SKX_-SAmtcCj+vuUvcdq-SWzKs86BKMjBcC8GhJ1gg@mail.gmail.com>
 <dd58bbf5-7983-ca26-c335-6bf8e492fcaa@schaufler-ca.com>
 <CAP_N_Z9iCP_xNNNSRVEzgGER7Zg+bb_nROzBUct=V6UyWn1P5A@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <2409eb92-aff5-7e1f-db9d-3c3ff3a12ad7@schaufler-ca.com>
Date:   Mon, 20 Sep 2021 16:44:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAP_N_Z9iCP_xNNNSRVEzgGER7Zg+bb_nROzBUct=V6UyWn1P5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19043 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/2021 3:35 PM, Jiang Wang . wrote:
> On Wed, Sep 15, 2021 at 9:52 AM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 9/13/2021 4:47 PM, Paul Moore wrote:
>>> On Mon, Sep 13, 2021 at 6:53 PM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>> Commit 77462de14a43f4d98dbd8de0f5743a4e02450b1d
>>>>
>>>>         af_unix: Add read_sock for stream socket types
>>>>
>>>> introduced a regression in UDS socket connections for the Smack LSM.=

>>>> I have not tracked done the details of why the change broke the code=
,
>>>> but this is where bisecting the kernel indicates the problem lies, a=
nd
>>>> I have verified that reverting this change repairs the problem.
>>>>
>>>> You can verify the problem with the Smack test suite:
>>>>
>>>>         https://github.com/smack-team/smack-testsuite.git
>>>>
>>>> The failing test is tests/uds-access.sh.
>>>>
> I tried to reproduce with tests/uds-access.sh, but the first two test
> cases always failed.

That was my initial impression as well. However, when I started
running the tests outside the routine "make test-results" I started
observing that they succeeded irregularly.

My biggest concern is that the test ever fails. The uds-access test
has not failed in several releases. The erratic behavior just adds
spice to the problem.=20

>  I tried different kernels with and without my
> unix-stream sockmap patches. Also tried standard debian 4.19
> kernel and they all have the same result.  What distro did you use? cen=
tos?
> Fedora?

I have been testing on Fedora32 and Fedora34.

>  Have you tested on debian based distros?

Ubuntu 20.04.3 with a 5.15-rc1 kernel is exhibiting the same
behavior. The Ubuntu system fails the test more regularly, but
does succeed on occasion.

> failing log:
> root@gitlab-runner-stretch:~/smack-testsuite# tests/uds-access.sh -v

# tools/clean-targets.sh
# tests/uds-access.sh -v

will remove the UDS filesystem entry before the test runs.
=C2=A0

> mkdir: cannot create directory =E2=80=98./targets/uds-notroot=E2=80=99:=
 File exists
> tests/uds-access.sh:71 FAIL
> tests/uds-access.sh:76 FAIL
> tests/uds-access.sh:81 PASS
> tests/uds-access.sh:86 PASS
> tests/uds-access.sh:91 PASS
> tests/uds-access.sh PASS=3D3 FAIL=3D2
> root@gitlab-runner-stretch:~/smack-testsuite# uname -a
> Linux gitlab-runner-stretch 5.14.0-rc5.bm.1-amd64+ #6 SMP Mon Sep 20
> 22:01:10 UTC 2021 x86_64 GNU/Linux
> root@gitlab-runner-stretch:~/smack-testsuite#
>
>>>> I have not looked to see if there's a similar problem with SELinux.
>>>> There may be, but if there isn't it doesn't matter, there's still a
>>>> bug.
>>> FWIW, the selinux-testsuite tests ran clean today with v5.15-rc1 (it
>>> looks like this code is only in v5.15) but as Casey said, a regressio=
n
>>> is a regression.
>>>
>>> Casey, what actually fails on the Smack system with this commit?
>> This problem occurs with security=3Dnone as well as with security=3Dsm=
ack.
>>
>> There isn't a problem with connect, that always works correctly.
>> The problem is an unexpected read() failure in the connecting process.=

>> This doesn't occur all the time, and sometimes happens in the first
>> of my two tests, sometimes the second, sometimes neither and, you gues=
sed
>> it, sometimes both.
>>
>> Here's a sample socat log demonstrating the problem. The first run,
>> ending at "uds-access RC=3D0" behaves as expected. The second, ending
>> at "uds-access RC=3D1", demonstrates the read failure. This case was
> I tried to compare logs between RC=3D0 and RC=3D1, but they look  to me=

> not apple to apple comparison? The read syscall have different paramete=
rs
> and the syscall sequences are different. I am not sure which syscall
> is the first failure.  See more comments below.

The data being feed to socat is the Smack label, so the data passed acros=
s
the socket will be of different length ("Pop" vs. "Snap") between the
two test cases, but that should be the only difference.


>> run with Smack enabled, but I see the same problem with the same
>> unpredictability on the same kernel with security=3Dnone.
>>
>> I've tried to convince myself that there's a flaw in the way I've
>> set up the scripts. They've been pretty robust and I've never seen
>> socat behaving erratically before. I've instrumented the kernel
>> code and all the security checks are behaving as expected. Plus,
>> as I mentioned above, the problem also occurs without an LSM.
>>
>> 2021/09/15 08:49:50 socat[2215] D getpid()
>> 2021/09/15 08:49:50 socat[2215] D getpid() -> 2215
>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PID", "2215", 1)
>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PPID", "2215", 1)
>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
>> 2021/09/15 08:49:50 socat[2215] I socat by Gerhard Rieger and contribu=
tors - see www.dest-unreach.org
>> 2021/09/15 08:49:50 socat[2215] I This product includes software devel=
oped by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.o=
penssl.org/)
>> 2021/09/15 08:49:50 socat[2215] I This product includes software writt=
en by Tim Hudson (tjh@cryptsoft.com)
>> 2021/09/15 08:49:50 socat[2215] D socat version 1.7.4.1 on Jan 27 2021=
 00:00:00
>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_VERSION", "1.7.4.1", 1=
)
>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
>> 2021/09/15 08:49:50 socat[2215] D running on Linux version #58 SMP Wed=
 Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
>>
>> 2021/09/15 08:49:50 socat[2215] D argv[0]: "socat"
>> 2021/09/15 08:49:50 socat[2215] D argv[1]: "-d"
>> 2021/09/15 08:49:50 socat[2215] D argv[2]: "-d"
>> 2021/09/15 08:49:50 socat[2215] D argv[3]: "-d"
>> 2021/09/15 08:49:50 socat[2215] D argv[4]: "-d"
>> 2021/09/15 08:49:50 socat[2215] D argv[5]: "-"
>> 2021/09/15 08:49:50 socat[2215] D argv[6]: "UNIX-CONNECT:./targets/uds=
-notroot/uds-access-socket"
>> 2021/09/15 08:49:50 socat[2215] D sigaction(1, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(2, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(3, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(4, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(6, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(7, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(8, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(11, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D sigaction(15, 0x7fffaec50b50, 0x0)
>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>> 2021/09/15 08:49:50 socat[2215] D signal(13, 0x1)
>> 2021/09/15 08:49:50 socat[2215] D signal() -> 0x0
>> 2021/09/15 08:49:50 socat[2215] D atexit(0x55aa5d645110)
>> 2021/09/15 08:49:50 socat[2215] D atexit() -> 0
>> 2021/09/15 08:49:50 socat[2215] D xioopen("-")
>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f0139d0
>> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f013d30
>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014140
>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014bc0
>> 2021/09/15 08:49:50 socat[2215] D isatty(0)
>> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
>> 2021/09/15 08:49:50 socat[2215] D isatty(1)
>> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f00
>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f90
>> 2021/09/15 08:49:50 socat[2215] N reading from and writing to stdio
>> 2021/09/15 08:49:50 socat[2215] D xioopen("UNIX-CONNECT:./targets/uds-=
notroot/uds-access-socket")
>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f015020
>> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015360
>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015770
>> 2021/09/15 08:49:50 socat[2215] N opening connection to AF=3D1 "./targ=
ets/uds-notroot/uds-access-socket"
>> 2021/09/15 08:49:50 socat[2215] D socket(1, 1, 0)
>> 2021/09/15 08:49:50 socat[2215] I socket(1, 1, 0) -> 5
>> 2021/09/15 08:49:50 socat[2215] D fcntl(5, 2, 1)
>> 2021/09/15 08:49:50 socat[2215] D fcntl() -> 0
>> 2021/09/15 08:49:50 socat[2215] D connect(5, {1,AF=3D1 "./targets/uds-=
notroot/uds-access-socket"}, 41)
>> 2021/09/15 08:49:50 socat[2215] D connect() -> 0
>> 2021/09/15 08:49:50 socat[2215] D getsockname(5, 0x7fffaec50580, 0x7ff=
faec50564{112})
>> 2021/09/15 08:49:50 socat[2215] D getsockname(, {AF=3D1 "<anon>"}, {2}=
) -> 0
>> 2021/09/15 08:49:50 socat[2215] N successfully connected from local ad=
dress AF=3D1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
>> 2021/09/15 08:49:50 socat[2215] I resolved and opened all sock address=
es
>> 2021/09/15 08:49:50 socat[2215] D posix_memalign(0x7fffaec50b28, 4096,=
 16385)
>> 2021/09/15 08:49:50 socat[2215] D posix_memalign(...) -> 0
>> 2021/09/15 08:49:50 socat[2215] N starting data transfer loop with FDs=
 [0,1] and [5,5]
>> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=3D0, sock2->eo=
f=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
>> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0=
=2E000000)
>> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0=
=2E000000), 4
>> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
>> 2021/09/15 08:49:50 socat[2215] D read -> 4
>> 2021/09/15 08:49:50 socat[2215] D write(5, 0x55aa5f016000, 4)
>> Pop
>> 2021/09/15 08:49:50 socat[2215] D write -> 4
>> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 0 to 5
>> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
>> 2021/09/15 08:49:50 socat[2215] D read -> 4
>> 2021/09/15 08:49:50 socat[2215] D write(1, 0x55aa5f016000, 4)
>> Pop
>> 2021/09/15 08:49:50 socat[2215] D write -> 4
>> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 5 to 1
>> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=3D0, sock2->eo=
f=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
>> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0=
=2E000000)
>> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0=
=2E000000), 4
>> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
>> 2021/09/15 08:49:50 socat[2215] D read -> 0
>> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
>> 2021/09/15 08:49:50 socat[2215] D read -> 0
>> 2021/09/15 08:49:50 socat[2215] N socket 1 (fd 0) is at EOF
>> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 1)
>> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
>> 2021/09/15 08:49:50 socat[2215] N socket 2 (fd 5) is at EOF
>> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 2)
>> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
>> 2021/09/15 08:49:50 socat[2215] N exiting with status 0
>> 2021/09/15 08:49:50 socat[2215] D exit(0)
>> 2021/09/15 08:49:50 socat[2215] D starting xioexit()
>> 2021/09/15 08:49:50 socat[2215] D finished xioexit()
>> uds-access RC=3D0
>> 2021/09/15 08:49:52 socat[2240] D getpid()
>> 2021/09/15 08:49:52 socat[2240] D getpid() -> 2240
>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PID", "2240", 1)
>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PPID", "2240", 1)
>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
>> 2021/09/15 08:49:52 socat[2240] I socat by Gerhard Rieger and contribu=
tors - see www.dest-unreach.org
>> 2021/09/15 08:49:52 socat[2240] I This product includes software devel=
oped by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.o=
penssl.org/)
>> 2021/09/15 08:49:52 socat[2240] I This product includes software writt=
en by Tim Hudson (tjh@cryptsoft.com)
>> 2021/09/15 08:49:52 socat[2240] D socat version 1.7.4.1 on Jan 27 2021=
 00:00:00
>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_VERSION", "1.7.4.1", 1=
)
>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
>> 2021/09/15 08:49:52 socat[2240] D running on Linux version #58 SMP Wed=
 Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
>>
>> 2021/09/15 08:49:52 socat[2240] D argv[0]: "socat"
>> 2021/09/15 08:49:52 socat[2240] D argv[1]: "-d"
>> 2021/09/15 08:49:52 socat[2240] D argv[2]: "-d"
>> 2021/09/15 08:49:52 socat[2240] D argv[3]: "-d"
>> 2021/09/15 08:49:52 socat[2240] D argv[4]: "-d"
>> 2021/09/15 08:49:52 socat[2240] D argv[5]: "-"
>> 2021/09/15 08:49:52 socat[2240] D argv[6]: "UNIX-CONNECT:./targets/uds=
-notroot/uds-access-socket"
>> 2021/09/15 08:49:52 socat[2240] D sigaction(1, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(2, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(3, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(4, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(6, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(7, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(8, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(11, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D sigaction(15, 0x7ffcca7e26c0, 0x0)
>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>> 2021/09/15 08:49:52 socat[2240] D signal(13, 0x1)
>> 2021/09/15 08:49:52 socat[2240] D signal() -> 0x0
>> 2021/09/15 08:49:52 socat[2240] D atexit(0x560590a15110)
>> 2021/09/15 08:49:52 socat[2240] D atexit() -> 0
>> 2021/09/15 08:49:52 socat[2240] D xioopen("-")
>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e899d0
>> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e89d30
>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8a140
>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8abc0
>> 2021/09/15 08:49:52 socat[2240] D isatty(0)
>> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
>> 2021/09/15 08:49:52 socat[2240] D isatty(1)
>> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af00
>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af90
>> 2021/09/15 08:49:52 socat[2240] N reading from and writing to stdio
>> 2021/09/15 08:49:52 socat[2240] D xioopen("UNIX-CONNECT:./targets/uds-=
notroot/uds-access-socket")
>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8b020
>> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b360
>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b770
>> 2021/09/15 08:49:52 socat[2240] N opening connection to AF=3D1 "./targ=
ets/uds-notroot/uds-access-socket"
>> 2021/09/15 08:49:52 socat[2240] D socket(1, 1, 0)
>> 2021/09/15 08:49:52 socat[2240] I socket(1, 1, 0) -> 5
>> 2021/09/15 08:49:52 socat[2240] D fcntl(5, 2, 1)
>> 2021/09/15 08:49:52 socat[2240] D fcntl() -> 0
>> 2021/09/15 08:49:52 socat[2240] D connect(5, {1,AF=3D1 "./targets/uds-=
notroot/uds-access-socket"}, 41)
>> 2021/09/15 08:49:52 socat[2240] D connect() -> 0
>> 2021/09/15 08:49:52 socat[2240] D getsockname(5, 0x7ffcca7e20f0, 0x7ff=
cca7e20d4{112})
>> 2021/09/15 08:49:52 socat[2240] D getsockname(, {AF=3D1 "<anon>"}, {2}=
) -> 0
>> 2021/09/15 08:49:52 socat[2240] N successfully connected from local ad=
dress AF=3D1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
>> 2021/09/15 08:49:52 socat[2240] I resolved and opened all sock address=
es
>> 2021/09/15 08:49:52 socat[2240] D posix_memalign(0x7ffcca7e2698, 4096,=
 16385)
>> 2021/09/15 08:49:52 socat[2240] D posix_memalign(...) -> 0
>> 2021/09/15 08:49:52 socat[2240] N starting data transfer loop with FDs=
 [0,1] and [5,5]
>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D0, sock2->eo=
f=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x22, &0x0, NULL/0=
=2E000000)
>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x22, 0x0, NULL/0.=
000000), 3
>> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
>> 2021/09/15 08:49:52 socat[2240] D read -> 5
>> 2021/09/15 08:49:52 socat[2240] D write(5, 0x560591e8c000, 5)
>> 2021/09/15 08:49:52 socat[2240] D write -> 5
>> 2021/09/15 08:49:52 socat[2240] I transferred 5 bytes from 0 to 5
>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D0, sock2->eo=
f=3D0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x20, &0x0, NULL/0=
=2E000000)
>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x20, 0x0, NULL/0.=
000000), 2
>> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
>> 2021/09/15 08:49:52 socat[2240] D read -> 0
>> 2021/09/15 08:49:52 socat[2240] N socket 1 (fd 0) is at EOF
>> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 1)
>> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
> Is this shutdown expected?

I'm not an expert on the internals of socat, but I don't think it
is expected.

> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D3, sock2->eof=
=3D0, closing=3D1, wasaction=3D1, total_to=3D{0.000000}
> 2021/09/15 08:49:52 socat[2240] D select(6, &0x20, &0x0, &0x0, &0.50000=
0)
> Snap
> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x20, 0x0, 0x0, &0.50000=
0), 1
> 2021/09/15 08:49:52 socat[2240] D read(5, 0x560591e8c000, 8192)
> 2021/09/15 08:49:52 socat[2240] D read -> -1
> This read failure seems due to the previous shutdown, right?

Again, I'm not the socat expert, but that would seem reasonable
to me.


>> 2021/09/15 08:49:52 socat[2240] E read(5, 0x560591e8c000, 8192): Inval=
id argument
>> 2021/09/15 08:49:52 socat[2240] N exit(1)
>> 2021/09/15 08:49:52 socat[2240] D starting xioexit()
>> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 2)
>> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
>> 2021/09/15 08:49:52 socat[2240] D finished xioexit()
>> uds-access RC=3D1
>>
>>
>>
>>

