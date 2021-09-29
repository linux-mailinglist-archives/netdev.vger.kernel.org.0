Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B6141C8A0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345370AbhI2Ppm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:45:42 -0400
Received: from sonic312-29.consmr.mail.ne1.yahoo.com ([66.163.191.210]:40101
        "EHLO sonic312-29.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245376AbhI2Ppl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632930239; bh=aNaWVvo+vg7wRJrLo1zPfzZuoGTFywQJBfEEypuuknA=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=sKS/PYv9/vjik6QxLuoSO5NgXjYXvzx6cCm9lVDxAj2gRTNwA7EpIfAa1GbiwYPm3JOpEDQaBOjwqkF2HY/RgMtYvhSmkFm52slmw76Ix/MJbOMYiVsF+d4JBu0fX57fQs6TE/OaUdM7LLC8sXZub9EisC2owfTyP1GcVyiSbOCwSSdowJS50m8KvUXskLOG0V7QlYeC2+gNbBXOkoF9RhMeXOspJtT9xUi53F7EAM0we5ziRkc8Y4Kv+WsS3QHoploC3wJkcC9WHfLxFQoAokO34nfF1kHPVeF0Jpun3nvHw7Ze68I+YH2iwkE49GnVX5w1atWAwT341xUsTukc0w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1632930239; bh=VOw1L/AaTx9/MFuhf6X7w7OCnKH5k9Kfujqo18frgF1=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=m2NKcn65xg5+Et7m9tEOoscYnk86o1GmCHm163z439mJ/uSxi7QR3bEB+RzgU/Rhssb72HWLmewdIRtUKKvjuLsHm2Ti6u9HU/qd6opbTqG4DF6rIJD1Hv2dLzDkYeGgG/m4ClDPpwpNQ/VQR5fOq6JvMTdvvEkQ2HZntQJjTGAlN3oHCm9NBm0CIwuHNC1QTH15Bz+fYga4l8N9uf1pOlloZX3uFReRAvEJawFY3kOu9uqaRvTQyH9HYElaQdEDfxTmPzV1X3nHtO2hnAu1fI1ePtk2sxb7RdpjsaRsmf2qN+RXcTxI2PkOOnXLoxyYcP/DED6+jK5I3W7Hx1WehA==
X-YMail-OSG: RsY2h_MVM1n5U0vIqYSZvRQUH74.UgsTF_45xh31LR05dx.riBJN2EEY20FF6i9
 Dzx_G6f.eEhSRj5AZglKg.Z1Sp3d5AgxwhmIoeSNKrA.Gwz.ZlBKrIkGLWQh0m.vmqP695PjwE_C
 TKE2Vp_MItlx96LY7n25sHU5.TxD_pN.WOd7zx1ZtgbH1cPT5k_klgnytZLLgajrKq67_iZ0ffVV
 6MiRC7kGf7fXgArrth_fAwkFOwf_DGh9VMsQW3Xq_anmmKzmnpYM1OIPYqxcZCs32NRvpy7VMu6x
 E3beMDy9ZlCQFnel6zCp.x7vgtHERUqVu5C7zMqoqtv_etW7Ne5pnlo4T1pBCg4WQH.w_yo9vAi0
 Lpsf.wMtXXTfdUl0jTj.6SE2EcOdzw_Re54u7gkHOkNGhTxbxm_2RAxbqFcyi9ulqwejf9iHvVQU
 HFDNEbV7p6RLbJLpEK7ULJl1HkEpJBXsKo6ELGnCByg3jLz7_ORim2ATE.hoyYR4SNxuF85.q3bi
 gzaf6dR_HLKy969oWucEv3bKq_keuv_BjoeBCTAKEys_6CG2gXvwavLNEnP53bv_jTl4IP_rhuRa
 V2MD17gGkTcU0JdUvPmusbt.wy68gLgSyZncxS9hg3e3CmWdAIUsyoDq.zYLvBzJIm1V3NQYH4L.
 6dBkrvF5wzrgPPpSTK9CxJ_ozCNMF44qL_H77Es4NKUA9oSBlViJ0eiM8N6HwlqEutXrT2ZC0tKC
 9dPAe1534IbQzHU.P4aFdSTN22xMJFbl91vJaqxt4cjSdBxL3EHuVMlA2PZ0tnUaysk6MLSVxEL5
 HBlH6Ti.ezS66b.9itx4Z2rjwq5X.YxXL7kJtGIDwaFkj.ksKXSY1WK18ITffBrV2uRZB9HDxUO9
 f21C9PHmde5NtXbDD84fHc_42o9QLKHvBpaTwDk9jYUvESYgQVzngl3YakiAo1.ZFSr6JPV8GRQb
 vfPPEGfunQgZLqB059ESdQW6NkPUe7UMX0HIRHpkYKautMnkI9EoI8OvJtcDXoqS9.taPsEmpdn.
 ZNLiKMYRamlsDJ9nb7hglExz8j0aobaB88EtSwghWd0g3lpqne2F7voQuWqvUZIJY0Gz8RvJyl45
 2DqXNtnyAthAWb4BFN3HYrODW8yTemLgd3tYxEy_AZFsPIrXY6hZ_rCOi3YkppK1YtyqQNNInyTt
 .hzVpGKoLlAIXFwCFAPssmLoWmw9e55U_9EgchLnKotUI.RltZrxUhPDkHWa0bFFaiNTRV3H.fxF
 y1VJu4K6K8.z.C3Dz_Uc8FNtKLlgcO4G_AzKNsUgeqEQsQlHDdpUzgZJRTY4eqenz.r3ts9hoK3i
 aUSQQhlo7qPN.HPCca9oTEqPlyQoU8bbpT21xKEjtNs9IXwIUJhRyDnZGTgcflTVzWdZA5sVPJIu
 u3U0wf1dIe0bgSbb7CZ8p9WMQEesDDIrX7yNF2srnng8Sxwd.5ZkzcHavXfGWPDGx848EpIsWcnW
 7D4hArosEInPvGFnzLUVNKVDLx1le8D20hX8JI9WNP.nrgai5YvUH6iUpkL4XKlsHhTz2Gas1ov5
 0QiIGJsY6nHjVwDShAIxvSu239k701YIVJU91h4GD5i89rqmlx08D10dWN7qC7OeRtI7WUMskWzV
 La_Pt3949kf5.zRFrqWwF.MJytWTtyCmM9NrqfKZGxw_4WDWPh51k8Fdx8uFetAuRaaJgD8rIcdw
 sGTExY3OfAUDhcuGFvsn2io6X6z5lVgdiApBbZgkQFQ1ZCHRGMa8Eu9PSh3lPWV654YSbNO51XJs
 Sx1Q2we928UYbwk1O9Cmu2lhgePG9pmNVN00LUbCSFBKcCLD4VGKFsyzB62WYZdhwPb9vppjn72Z
 B4h24EpwLJaUc.yEyDEiIP3HZJK_PtOLha_qaCbWtBoePDqXwcAxH.cBSf2NcWQBef9Kbtt7FgER
 CH43W3bZs5NRjr3jA30.ReFwwVvPIpZZg0inxC.2JFwarv8Pc6zwD1Z9jHAC56YZMooIXWndtF0O
 l33tc2PGr2rBo.1MB1p2Cl4qSJlcH7bfDsYj3RpG247ynW9P.VqgRyhCIfU7.4Zpvs7CP_XAvxjL
 X0RW3DTa7aqTvbVBPhkvhvc6VCVsqQUY7OC6r8pxWjsQQ9gGwlx379quNcLd_Kq.HTbwDdTtZj6Z
 LQjoSbJJOp7gwkZzzZMFjBi.nlFDSgEt2fNl3t4Fz8Jr._XBPVFSYVkeonWkfE0EJgA73g_FBiIm
 la21E0dcq_FjQZYVuyXwSkOErCll4DGzHlPpV0_atwFiNnYwaHkh5yUIGdIjIJnMikVYzGmszpHU
 O1RvzZGAZYoWUOAOgEM7j2_PREzA5YMlfLB3.oCP1JAo-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Wed, 29 Sep 2021 15:43:59 +0000
Received: by kubenode588.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d5d7dd6fd2fa6f2df65872353c2215c0;
          Wed, 29 Sep 2021 15:43:57 +0000 (UTC)
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
 <2409eb92-aff5-7e1f-db9d-3c3ff3a12ad7@schaufler-ca.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <5fd9974b-531b-b7e9-81d3-ffefbad3ee96@schaufler-ca.com>
Date:   Wed, 29 Sep 2021 08:43:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2409eb92-aff5-7e1f-db9d-3c3ff3a12ad7@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Mailer: WebService/1.1.19076 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/2021 4:44 PM, Casey Schaufler wrote:
> On 9/20/2021 3:35 PM, Jiang Wang . wrote:
>> On Wed, Sep 15, 2021 at 9:52 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> On 9/13/2021 4:47 PM, Paul Moore wrote:
>>>> On Mon, Sep 13, 2021 at 6:53 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>> Commit 77462de14a43f4d98dbd8de0f5743a4e02450b1d
>>>>>
>>>>>         af_unix: Add read_sock for stream socket types
>>>>>
>>>>> introduced a regression in UDS socket connections for the Smack LSM.
>>>>> I have not tracked done the details of why the change broke the code,
>>>>> but this is where bisecting the kernel indicates the problem lies, and
>>>>> I have verified that reverting this change repairs the problem.
>>>>>
>>>>> You can verify the problem with the Smack test suite:
>>>>>
>>>>>         https://github.com/smack-team/smack-testsuite.git
>>>>>
>>>>> The failing test is tests/uds-access.sh.
>>>>>
>> I tried to reproduce with tests/uds-access.sh, but the first two test
>> cases always failed.

Just piping in that the behavior hasn't changed in 5.15-rc3.
It still usually fails, with the occasional success. These
tests used to succeed.

> That was my initial impression as well. However, when I started
> running the tests outside the routine "make test-results" I started
> observing that they succeeded irregularly.
>
> My biggest concern is that the test ever fails. The uds-access test
> has not failed in several releases. The erratic behavior just adds
> spice to the problem. 
>
>>  I tried different kernels with and without my
>> unix-stream sockmap patches. Also tried standard debian 4.19
>> kernel and they all have the same result.  What distro did you use? centos?
>> Fedora?
> I have been testing on Fedora32 and Fedora34.
>
>>  Have you tested on debian based distros?
> Ubuntu 20.04.3 with a 5.15-rc1 kernel is exhibiting the same
> behavior. The Ubuntu system fails the test more regularly, but
> does succeed on occasion.
>
>> failing log:
>> root@gitlab-runner-stretch:~/smack-testsuite# tests/uds-access.sh -v
> # tools/clean-targets.sh
> # tests/uds-access.sh -v
>
> will remove the UDS filesystem entry before the test runs.
>  
>
>> mkdir: cannot create directory ‘./targets/uds-notroot’: File exists
>> tests/uds-access.sh:71 FAIL
>> tests/uds-access.sh:76 FAIL
>> tests/uds-access.sh:81 PASS
>> tests/uds-access.sh:86 PASS
>> tests/uds-access.sh:91 PASS
>> tests/uds-access.sh PASS=3 FAIL=2
>> root@gitlab-runner-stretch:~/smack-testsuite# uname -a
>> Linux gitlab-runner-stretch 5.14.0-rc5.bm.1-amd64+ #6 SMP Mon Sep 20
>> 22:01:10 UTC 2021 x86_64 GNU/Linux
>> root@gitlab-runner-stretch:~/smack-testsuite#
>>
>>>>> I have not looked to see if there's a similar problem with SELinux.
>>>>> There may be, but if there isn't it doesn't matter, there's still a
>>>>> bug.
>>>> FWIW, the selinux-testsuite tests ran clean today with v5.15-rc1 (it
>>>> looks like this code is only in v5.15) but as Casey said, a regression
>>>> is a regression.
>>>>
>>>> Casey, what actually fails on the Smack system with this commit?
>>> This problem occurs with security=none as well as with security=smack.
>>>
>>> There isn't a problem with connect, that always works correctly.
>>> The problem is an unexpected read() failure in the connecting process.
>>> This doesn't occur all the time, and sometimes happens in the first
>>> of my two tests, sometimes the second, sometimes neither and, you guessed
>>> it, sometimes both.
>>>
>>> Here's a sample socat log demonstrating the problem. The first run,
>>> ending at "uds-access RC=0" behaves as expected. The second, ending
>>> at "uds-access RC=1", demonstrates the read failure. This case was
>> I tried to compare logs between RC=0 and RC=1, but they look  to me
>> not apple to apple comparison? The read syscall have different parameters
>> and the syscall sequences are different. I am not sure which syscall
>> is the first failure.  See more comments below.
> The data being feed to socat is the Smack label, so the data passed across
> the socket will be of different length ("Pop" vs. "Snap") between the
> two test cases, but that should be the only difference.
>
>
>>> run with Smack enabled, but I see the same problem with the same
>>> unpredictability on the same kernel with security=none.
>>>
>>> I've tried to convince myself that there's a flaw in the way I've
>>> set up the scripts. They've been pretty robust and I've never seen
>>> socat behaving erratically before. I've instrumented the kernel
>>> code and all the security checks are behaving as expected. Plus,
>>> as I mentioned above, the problem also occurs without an LSM.
>>>
>>> 2021/09/15 08:49:50 socat[2215] D getpid()
>>> 2021/09/15 08:49:50 socat[2215] D getpid() -> 2215
>>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PID", "2215", 1)
>>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PPID", "2215", 1)
>>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
>>> 2021/09/15 08:49:50 socat[2215] I socat by Gerhard Rieger and contributors - see www.dest-unreach.org
>>> 2021/09/15 08:49:50 socat[2215] I This product includes software developed by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.openssl.org/)
>>> 2021/09/15 08:49:50 socat[2215] I This product includes software written by Tim Hudson (tjh@cryptsoft.com)
>>> 2021/09/15 08:49:50 socat[2215] D socat version 1.7.4.1 on Jan 27 2021 00:00:00
>>> 2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_VERSION", "1.7.4.1", 1)
>>> 2021/09/15 08:49:50 socat[2215] D setenv() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D running on Linux version #58 SMP Wed Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
>>>
>>> 2021/09/15 08:49:50 socat[2215] D argv[0]: "socat"
>>> 2021/09/15 08:49:50 socat[2215] D argv[1]: "-d"
>>> 2021/09/15 08:49:50 socat[2215] D argv[2]: "-d"
>>> 2021/09/15 08:49:50 socat[2215] D argv[3]: "-d"
>>> 2021/09/15 08:49:50 socat[2215] D argv[4]: "-d"
>>> 2021/09/15 08:49:50 socat[2215] D argv[5]: "-"
>>> 2021/09/15 08:49:50 socat[2215] D argv[6]: "UNIX-CONNECT:./targets/uds-notroot/uds-access-socket"
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(1, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(2, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(3, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(4, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(6, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(7, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(8, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(11, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D sigaction(15, 0x7fffaec50b50, 0x0)
>>> 2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D signal(13, 0x1)
>>> 2021/09/15 08:49:50 socat[2215] D signal() -> 0x0
>>> 2021/09/15 08:49:50 socat[2215] D atexit(0x55aa5d645110)
>>> 2021/09/15 08:49:50 socat[2215] D atexit() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D xioopen("-")
>>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f0139d0
>>> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
>>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f013d30
>>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014140
>>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014bc0
>>> 2021/09/15 08:49:50 socat[2215] D isatty(0)
>>> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D isatty(1)
>>> 2021/09/15 08:49:50 socat[2215] D isatty() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
>>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f00
>>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
>>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f90
>>> 2021/09/15 08:49:50 socat[2215] N reading from and writing to stdio
>>> 2021/09/15 08:49:50 socat[2215] D xioopen("UNIX-CONNECT:./targets/uds-notroot/uds-access-socket")
>>> 2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
>>> 2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f015020
>>> 2021/09/15 08:49:50 socat[2215] D malloc(1024)
>>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015360
>>> 2021/09/15 08:49:50 socat[2215] D malloc(128)
>>> 2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015770
>>> 2021/09/15 08:49:50 socat[2215] N opening connection to AF=1 "./targets/uds-notroot/uds-access-socket"
>>> 2021/09/15 08:49:50 socat[2215] D socket(1, 1, 0)
>>> 2021/09/15 08:49:50 socat[2215] I socket(1, 1, 0) -> 5
>>> 2021/09/15 08:49:50 socat[2215] D fcntl(5, 2, 1)
>>> 2021/09/15 08:49:50 socat[2215] D fcntl() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D connect(5, {1,AF=1 "./targets/uds-notroot/uds-access-socket"}, 41)
>>> 2021/09/15 08:49:50 socat[2215] D connect() -> 0
>>> 2021/09/15 08:49:50 socat[2215] D getsockname(5, 0x7fffaec50580, 0x7fffaec50564{112})
>>> 2021/09/15 08:49:50 socat[2215] D getsockname(, {AF=1 "<anon>"}, {2}) -> 0
>>> 2021/09/15 08:49:50 socat[2215] N successfully connected from local address AF=1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
>>> 2021/09/15 08:49:50 socat[2215] I resolved and opened all sock addresses
>>> 2021/09/15 08:49:50 socat[2215] D posix_memalign(0x7fffaec50b28, 4096, 16385)
>>> 2021/09/15 08:49:50 socat[2215] D posix_memalign(...) -> 0
>>> 2021/09/15 08:49:50 socat[2215] N starting data transfer loop with FDs [0,1] and [5,5]
>>> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
>>> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0.000000)
>>> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0.000000), 4
>>> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
>>> 2021/09/15 08:49:50 socat[2215] D read -> 4
>>> 2021/09/15 08:49:50 socat[2215] D write(5, 0x55aa5f016000, 4)
>>> Pop
>>> 2021/09/15 08:49:50 socat[2215] D write -> 4
>>> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 0 to 5
>>> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
>>> 2021/09/15 08:49:50 socat[2215] D read -> 4
>>> 2021/09/15 08:49:50 socat[2215] D write(1, 0x55aa5f016000, 4)
>>> Pop
>>> 2021/09/15 08:49:50 socat[2215] D write -> 4
>>> 2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 5 to 1
>>> 2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
>>> 2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0.000000)
>>> 2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0.000000), 4
>>> 2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
>>> 2021/09/15 08:49:50 socat[2215] D read -> 0
>>> 2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
>>> 2021/09/15 08:49:50 socat[2215] D read -> 0
>>> 2021/09/15 08:49:50 socat[2215] N socket 1 (fd 0) is at EOF
>>> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 1)
>>> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
>>> 2021/09/15 08:49:50 socat[2215] N socket 2 (fd 5) is at EOF
>>> 2021/09/15 08:49:50 socat[2215] I shutdown(5, 2)
>>> 2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
>>> 2021/09/15 08:49:50 socat[2215] N exiting with status 0
>>> 2021/09/15 08:49:50 socat[2215] D exit(0)
>>> 2021/09/15 08:49:50 socat[2215] D starting xioexit()
>>> 2021/09/15 08:49:50 socat[2215] D finished xioexit()
>>> uds-access RC=0
>>> 2021/09/15 08:49:52 socat[2240] D getpid()
>>> 2021/09/15 08:49:52 socat[2240] D getpid() -> 2240
>>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PID", "2240", 1)
>>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PPID", "2240", 1)
>>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
>>> 2021/09/15 08:49:52 socat[2240] I socat by Gerhard Rieger and contributors - see www.dest-unreach.org
>>> 2021/09/15 08:49:52 socat[2240] I This product includes software developed by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.openssl.org/)
>>> 2021/09/15 08:49:52 socat[2240] I This product includes software written by Tim Hudson (tjh@cryptsoft.com)
>>> 2021/09/15 08:49:52 socat[2240] D socat version 1.7.4.1 on Jan 27 2021 00:00:00
>>> 2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_VERSION", "1.7.4.1", 1)
>>> 2021/09/15 08:49:52 socat[2240] D setenv() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D running on Linux version #58 SMP Wed Sep 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64
>>>
>>> 2021/09/15 08:49:52 socat[2240] D argv[0]: "socat"
>>> 2021/09/15 08:49:52 socat[2240] D argv[1]: "-d"
>>> 2021/09/15 08:49:52 socat[2240] D argv[2]: "-d"
>>> 2021/09/15 08:49:52 socat[2240] D argv[3]: "-d"
>>> 2021/09/15 08:49:52 socat[2240] D argv[4]: "-d"
>>> 2021/09/15 08:49:52 socat[2240] D argv[5]: "-"
>>> 2021/09/15 08:49:52 socat[2240] D argv[6]: "UNIX-CONNECT:./targets/uds-notroot/uds-access-socket"
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(1, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(2, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(3, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(4, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(6, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(7, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(8, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(11, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D sigaction(15, 0x7ffcca7e26c0, 0x0)
>>> 2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D signal(13, 0x1)
>>> 2021/09/15 08:49:52 socat[2240] D signal() -> 0x0
>>> 2021/09/15 08:49:52 socat[2240] D atexit(0x560590a15110)
>>> 2021/09/15 08:49:52 socat[2240] D atexit() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D xioopen("-")
>>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e899d0
>>> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
>>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e89d30
>>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8a140
>>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8abc0
>>> 2021/09/15 08:49:52 socat[2240] D isatty(0)
>>> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D isatty(1)
>>> 2021/09/15 08:49:52 socat[2240] D isatty() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
>>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af00
>>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
>>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af90
>>> 2021/09/15 08:49:52 socat[2240] N reading from and writing to stdio
>>> 2021/09/15 08:49:52 socat[2240] D xioopen("UNIX-CONNECT:./targets/uds-notroot/uds-access-socket")
>>> 2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
>>> 2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8b020
>>> 2021/09/15 08:49:52 socat[2240] D malloc(1024)
>>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b360
>>> 2021/09/15 08:49:52 socat[2240] D malloc(128)
>>> 2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b770
>>> 2021/09/15 08:49:52 socat[2240] N opening connection to AF=1 "./targets/uds-notroot/uds-access-socket"
>>> 2021/09/15 08:49:52 socat[2240] D socket(1, 1, 0)
>>> 2021/09/15 08:49:52 socat[2240] I socket(1, 1, 0) -> 5
>>> 2021/09/15 08:49:52 socat[2240] D fcntl(5, 2, 1)
>>> 2021/09/15 08:49:52 socat[2240] D fcntl() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D connect(5, {1,AF=1 "./targets/uds-notroot/uds-access-socket"}, 41)
>>> 2021/09/15 08:49:52 socat[2240] D connect() -> 0
>>> 2021/09/15 08:49:52 socat[2240] D getsockname(5, 0x7ffcca7e20f0, 0x7ffcca7e20d4{112})
>>> 2021/09/15 08:49:52 socat[2240] D getsockname(, {AF=1 "<anon>"}, {2}) -> 0
>>> 2021/09/15 08:49:52 socat[2240] N successfully connected from local address AF=1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
>>> 2021/09/15 08:49:52 socat[2240] I resolved and opened all sock addresses
>>> 2021/09/15 08:49:52 socat[2240] D posix_memalign(0x7ffcca7e2698, 4096, 16385)
>>> 2021/09/15 08:49:52 socat[2240] D posix_memalign(...) -> 0
>>> 2021/09/15 08:49:52 socat[2240] N starting data transfer loop with FDs [0,1] and [5,5]
>>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
>>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x22, &0x0, NULL/0.000000)
>>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x22, 0x0, NULL/0.000000), 3
>>> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
>>> 2021/09/15 08:49:52 socat[2240] D read -> 5
>>> 2021/09/15 08:49:52 socat[2240] D write(5, 0x560591e8c000, 5)
>>> 2021/09/15 08:49:52 socat[2240] D write -> 5
>>> 2021/09/15 08:49:52 socat[2240] I transferred 5 bytes from 0 to 5
>>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=0, sock2->eof=0, closing=0, wasaction=1, total_to={0.000000}
>>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x20, &0x0, NULL/0.000000)
>>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x20, 0x0, NULL/0.000000), 2
>>> 2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
>>> 2021/09/15 08:49:52 socat[2240] D read -> 0
>>> 2021/09/15 08:49:52 socat[2240] N socket 1 (fd 0) is at EOF
>>> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 1)
>>> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
>> Is this shutdown expected?
> I'm not an expert on the internals of socat, but I don't think it
> is expected.
>
>> 2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3, sock2->eof=0, closing=1, wasaction=1, total_to={0.000000}
>> 2021/09/15 08:49:52 socat[2240] D select(6, &0x20, &0x0, &0x0, &0.500000)
>> Snap
>> 2021/09/15 08:49:52 socat[2240] D select -> (, 0x20, 0x0, 0x0, &0.500000), 1
>> 2021/09/15 08:49:52 socat[2240] D read(5, 0x560591e8c000, 8192)
>> 2021/09/15 08:49:52 socat[2240] D read -> -1
>> This read failure seems due to the previous shutdown, right?
> Again, I'm not the socat expert, but that would seem reasonable
> to me.
>
>
>>> 2021/09/15 08:49:52 socat[2240] E read(5, 0x560591e8c000, 8192): Invalid argument
>>> 2021/09/15 08:49:52 socat[2240] N exit(1)
>>> 2021/09/15 08:49:52 socat[2240] D starting xioexit()
>>> 2021/09/15 08:49:52 socat[2240] I shutdown(5, 2)
>>> 2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
>>> 2021/09/15 08:49:52 socat[2240] D finished xioexit()
>>> uds-access RC=1
>>>
>>>
>>>
>>>
