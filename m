Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49E740CB40
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhIOQxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:53:23 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com ([66.163.187.38]:38892
        "EHLO sonic308-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229676AbhIOQxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1631724723; bh=8OsBQAEmYbQirWbEzOEU0rdx/zbceRiJdgiojyK/op8=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=KJaSrA/CeCXCZY+I5vVtsZLAXcBA04vIbkw5aCX74GaLhCRU0FxNXQqmu0WUUXJrFO8YuOcDJz4Ss2LUPirMDgxyLOSvaaDuv2uicHcxFtaqi31pqNGdDZQq8LMG83Ndq5jw6bEAuoEJrkxVhdhDyYO5soZuR8SU+EXJkiFSTH5hhGM4N3vAUloUK0CPmASnYZi1EDbJt7lYtX4V0DcAzFK4c3NpWHtXgnSIU0sco4aNtGSI2fOCaLsaKCr+fF7lyztFcmqmG23+OsXLetH8qCmsiVeIY+eOGH8TxGud8gn9Xt8pkavB1CJPgekQuPV8LGeEMwzdjLTmPEIJqzJALg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1631724723; bh=ri7OMIueXAICmsGifSmtK6dmnWuWIbfmvst9Y7U5UXh=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=bepyupE6BvZ743mR/FkiZiOrbLNeQPoMnF+7v015T/+DtJbOdPwQj/pKyEsS2HVfXB/sWfDjcCos0dDzEAUOoEoME0Ww0PjsOlc9kx3jQR1qiKK+1s3wS4Kil73qKIu74btZzY0pARFfFT6r6TPNN6xry5iDBRDKKcDaq91ZkbTNjbmAJZOrCtzhHS2dkWMdxYWikxQNnOTjItR24ud4YhR/1q3oKDFL1Nf7BeM8dlBHu0zNQX3ncaHhfEeULhwQ45sL/qbD8NOb6t0OS8fW5dAG9mq1g4/EzySS5jZmorfrSxTGK8rou1KPY/f1KgGlWiSlZ6tuCuiOw2T7sQg2RQ==
X-YMail-OSG: jB7Ze54VM1m9p.C0XgMPwzJcSPrVUukTYgkaAaYVdJnAeA2ME3PcVICp3FhbHsS
 3oTBhf32Vq20BucBvJp.SArzjK7HUAYkeAfQED1aPlksGyyI1uuBVAVkaAgz8aluo6xDqs9glBpM
 WKGWg77OMc_2QKMBVpe63WooIoyQoLU5UldxJFnzF_U4qdeaXiCtSbAGZUX4.DPxuyJZVhCe9ZR0
 agZg5NoI6ra4qaMCBBzxkEcf54PL7WWfP3IgnyaqPjMXnrcBOCi9lEYCjyoT3qg2BFUe1lJra9br
 0I2bBD3ahBXoYRKoWVEq10QnodSoBXX5xVWgMtvxS9xaKrhZCvEcjQJIgdmpZe.ZZ_RNge.ViyBy
 aGbJNkODwbS.EiUkLdX7QT_e_._diVdjAtZul4RARErpQV06EKLA1dPJ23oQUY.RGhMfj3kHvthj
 kiNyEijT9zHCwTNRKzn6g5uF4wRx20EmgBxykDWf9qmDP4Tylx56ofL6zYO5BjUcQjeGNFaqf1EP
 Fdz0wggReW0AYgOxGA3kwUpYtYGWN7Ftt_jiyUb393JaSGnmPLm4mK0igRye_U4X0gbMqIB1dy5l
 L.msM2SrNuVWOvlCD84MN.aCZWdHTTljLSVMPkVBQmbUZWGJuW9CKfndyai0nw_9LI5lj_sdNH0p
 cYYwmqDeqvFV8wqATkh6yHIj0PtvpnKUKhryv08aDQfRyt6Hh0hHY0Z2GK3.Ubkao7WOsc9k9TUw
 7UEyaQ64NEzoeE8TccuY1ZGZF.LzPbHY3jHleLrijn6t7Ulkia.wLFQPaax_np9jYzwL4eUd49j7
 7mIPsipR0WmGIkGsT_qvdcaCAu_LVBDsSlTE2JAEiGIP32.Ep7nHVzN2JFNnvOahOWMP_4wd8TC8
 .bxEF_x8ke44Al3hAVHses9Ahzvkd1Juyh8CewUHnkxd04ekpAJEezp1BZ2bBVW0Vt6sOdZCNy4_
 thq59Enyu9RS7s1Q94zKbLrXNN3ibUW3A_nojOPM9ECxjhgjsvqIjcDgA_kqfUKrauElVMrIBHYx
 HNnPJqjg2QMWTrPACm1s1NdgvMDuygsL_gTmRrkwB4ckkokkynxEndBpBN4Q9ixGGyOU2sgdBUuj
 fjL7QIdXNyA073v2sXVBPN9KN.Pvgpcixp0pjGoKyfxg3vkNHDLb6liGHrF5EM.YyCHWaH17Wrhi
 KYNCs2v6nZ5Ucd7427sbDiTlahmHqTsBvH.AEEX00QmUQEcbaCIb.3K0AHDgWdZV83KpoHGZHQLv
 BGwYHj3pUs.vSJhfezIw7oCWZnsu8f7oUhKHrlJo.YRvf6G5bH.W8zVB1Nl4Cg_JeYaJCApD3fg8
 VGuoB8wxVPen0ZcEw915idl9g0cxdMmijEWWCk5fxRVry50ArZJskYTX3qeFR1YMJYOFMU0tsBEN
 o8I566eNC0WP6pLpHVsmUPw_H6hXPm7AzEBb8QwjvuikjYTkjx46_ZnzBqNvNYp7EaxMJqrbc0p7
 nvyL9AGTuYvbFdJDdOtHPY8mrAzmNqR9TrLyFN5KNGweg.0rjzw9cJdABVLbHAfJxPus_aSCLvSG
 AhxGPvQsYAQ_dPOaHJNaMPPB6Q6yIoDOA8U4KeOlBJTgkWwO8JTuxDpwNKSJIAdjDOZInQRqCGGp
 PEm8SFXTkyP0QzeeNKwoxq.Pg2JBY_xMKHYxIkbFpUYgxtST8.wDkElVvphjm3ewwvqUDxz4Tnnz
 rflbsFrwHEj9bHAclnk7GClQgaqIbEpIIIoWPr7JGuFBntSBr5SstZ9PSy68ZSDrKG3d.OMQriax
 PCsr0u3J2cfCgURGOWI526jD9p0O4DIOHO8EFESYOVyO0yrbFkZKjtOHGwmHmjyCeMaBzwV78ocn
 qhIfqPFLegObgrpZv4RDxc41mIm4dIwGgsmDTCoGRmJMVfkhGvUqh5.pAs2PgaOjfDQldxfVCtJ2
 RkrCcvQeNAicsN6xd.5Cp.hKpCKd51uYPAbAjyZ7OV3d3eOwrr0XF.SZHXR9GULlNQ_iAobFdPe.
 mjEAhV2hxZv1Aen5n0Hh2cykL1CuB7QMDF8lELdHROPgjEBAn1Shf8uadWoLjYqDHfW3sVUUS_ET
 uBRRXimldVeXm0sV911qaH7v6vBbyWDVf0LSGPguIeyGoIeSJ6quWyawG4Q_PSdrD6RuUdE3z7Ol
 3xWsZ7y2tqeftg3u0.74U5cXkiD62aQIJ5FGvsuLF0x7xoO13WuZ7MzMVT3NfIMPFOPss0ZEU_Ju
 AByLJoze9ucAzjMySbbrnrPQqTaVu8OLUN9T7DuZHOHY_oZgRpm3sKDusa8b9AeBHJM9Y6Ck-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Wed, 15 Sep 2021 16:52:03 +0000
Received: by kubenode584.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e7eeaedbd502fe08050235c5f7bd0351;
          Wed, 15 Sep 2021 16:52:00 +0000 (UTC)
Subject: Re: Regression in unix stream sockets with the Smack LSM
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jiang Wang <jiang.wang@bytedance.com>,
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
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <dd58bbf5-7983-ca26-c335-6bf8e492fcaa@schaufler-ca.com>
Date:   Wed, 15 Sep 2021 09:51:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhR9SKX_-SAmtcCj+vuUvcdq-SWzKs86BKMjBcC8GhJ1gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19013 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/2021 4:47 PM, Paul Moore wrote:
> On Mon, Sep 13, 2021 at 6:53 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> Commit 77462de14a43f4d98dbd8de0f5743a4e02450b1d
>>
>>         af_unix: Add read_sock for stream socket types
>>
>> introduced a regression in UDS socket connections for the Smack LSM.
>> I have not tracked done the details of why the change broke the code,
>> but this is where bisecting the kernel indicates the problem lies, and=

>> I have verified that reverting this change repairs the problem.
>>
>> You can verify the problem with the Smack test suite:
>>
>>         https://github.com/smack-team/smack-testsuite.git
>>
>> The failing test is tests/uds-access.sh.
>>
>> I have not looked to see if there's a similar problem with SELinux.
>> There may be, but if there isn't it doesn't matter, there's still a
>> bug.
> FWIW, the selinux-testsuite tests ran clean today with v5.15-rc1 (it
> looks like this code is only in v5.15) but as Casey said, a regression
> is a regression.
>
> Casey, what actually fails on the Smack system with this commit?

This problem occurs with security=3Dnone as well as with security=3Dsmack=
=2E

There isn't a problem with connect, that always works correctly.
The problem is an unexpected read() failure in the connecting process.
This doesn't occur all the time, and sometimes happens in the first
of my two tests, sometimes the second, sometimes neither and, you guessed=

it, sometimes both.

Here's a sample socat log demonstrating the problem. The first run,
ending at "uds-access RC=3D0" behaves as expected. The second, ending
at "uds-access RC=3D1", demonstrates the read failure. This case was
run with Smack enabled, but I see the same problem with the same
unpredictability on the same kernel with security=3Dnone.

I've tried to convince myself that there's a flaw in the way I've
set up the scripts. They've been pretty robust and I've never seen
socat behaving erratically before. I've instrumented the kernel
code and all the security checks are behaving as expected. Plus,
as I mentioned above, the problem also occurs without an LSM.

2021/09/15 08:49:50 socat[2215] D getpid()
2021/09/15 08:49:50 socat[2215] D getpid() -> 2215
2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PID", "2215", 1)
2021/09/15 08:49:50 socat[2215] D setenv() -> 0
2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_PPID", "2215", 1)
2021/09/15 08:49:50 socat[2215] D setenv() -> 0
2021/09/15 08:49:50 socat[2215] I socat by Gerhard Rieger and contributor=
s - see www.dest-unreach.org
2021/09/15 08:49:50 socat[2215] I This product includes software develope=
d by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.open=
ssl.org/)
2021/09/15 08:49:50 socat[2215] I This product includes software written =
by Tim Hudson (tjh@cryptsoft.com)
2021/09/15 08:49:50 socat[2215] D socat version 1.7.4.1 on Jan 27 2021 00=
:00:00
2021/09/15 08:49:50 socat[2215] D setenv("SOCAT_VERSION", "1.7.4.1", 1)
2021/09/15 08:49:50 socat[2215] D setenv() -> 0
2021/09/15 08:49:50 socat[2215] D running on Linux version #58 SMP Wed Se=
p 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64

2021/09/15 08:49:50 socat[2215] D argv[0]: "socat"
2021/09/15 08:49:50 socat[2215] D argv[1]: "-d"
2021/09/15 08:49:50 socat[2215] D argv[2]: "-d"
2021/09/15 08:49:50 socat[2215] D argv[3]: "-d"
2021/09/15 08:49:50 socat[2215] D argv[4]: "-d"
2021/09/15 08:49:50 socat[2215] D argv[5]: "-"
2021/09/15 08:49:50 socat[2215] D argv[6]: "UNIX-CONNECT:./targets/uds-no=
troot/uds-access-socket"
2021/09/15 08:49:50 socat[2215] D sigaction(1, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(2, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(3, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(4, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(6, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(7, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(8, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(11, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D sigaction(15, 0x7fffaec50b50, 0x0)
2021/09/15 08:49:50 socat[2215] D sigaction() -> 0
2021/09/15 08:49:50 socat[2215] D signal(13, 0x1)
2021/09/15 08:49:50 socat[2215] D signal() -> 0x0
2021/09/15 08:49:50 socat[2215] D atexit(0x55aa5d645110)
2021/09/15 08:49:50 socat[2215] D atexit() -> 0
2021/09/15 08:49:50 socat[2215] D xioopen("-")
2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f0139d0
2021/09/15 08:49:50 socat[2215] D malloc(1024)
2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f013d30
2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014140
2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f014bc0
2021/09/15 08:49:50 socat[2215] D isatty(0)
2021/09/15 08:49:50 socat[2215] D isatty() -> 0
2021/09/15 08:49:50 socat[2215] D isatty(1)
2021/09/15 08:49:50 socat[2215] D isatty() -> 0
2021/09/15 08:49:50 socat[2215] D malloc(128)
2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f00
2021/09/15 08:49:50 socat[2215] D malloc(128)
2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f014f90
2021/09/15 08:49:50 socat[2215] N reading from and writing to stdio
2021/09/15 08:49:50 socat[2215] D xioopen("UNIX-CONNECT:./targets/uds-not=
root/uds-access-socket")
2021/09/15 08:49:50 socat[2215] D calloc(1, 824)
2021/09/15 08:49:50 socat[2215] D calloc() -> 0x55aa5f015020
2021/09/15 08:49:50 socat[2215] D malloc(1024)
2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015360
2021/09/15 08:49:50 socat[2215] D malloc(128)
2021/09/15 08:49:50 socat[2215] D malloc() -> 0x55aa5f015770
2021/09/15 08:49:50 socat[2215] N opening connection to AF=3D1 "./targets=
/uds-notroot/uds-access-socket"
2021/09/15 08:49:50 socat[2215] D socket(1, 1, 0)
2021/09/15 08:49:50 socat[2215] I socket(1, 1, 0) -> 5
2021/09/15 08:49:50 socat[2215] D fcntl(5, 2, 1)
2021/09/15 08:49:50 socat[2215] D fcntl() -> 0
2021/09/15 08:49:50 socat[2215] D connect(5, {1,AF=3D1 "./targets/uds-not=
root/uds-access-socket"}, 41)
2021/09/15 08:49:50 socat[2215] D connect() -> 0
2021/09/15 08:49:50 socat[2215] D getsockname(5, 0x7fffaec50580, 0x7fffae=
c50564{112})
2021/09/15 08:49:50 socat[2215] D getsockname(, {AF=3D1 "<anon>"}, {2}) -=
> 0
2021/09/15 08:49:50 socat[2215] N successfully connected from local addre=
ss AF=3D1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
2021/09/15 08:49:50 socat[2215] I resolved and opened all sock addresses
2021/09/15 08:49:50 socat[2215] D posix_memalign(0x7fffaec50b28, 4096, 16=
385)
2021/09/15 08:49:50 socat[2215] D posix_memalign(...) -> 0
2021/09/15 08:49:50 socat[2215] N starting data transfer loop with FDs [0=
,1] and [5,5]
2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=3D0, sock2->eof=3D=
0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0.00=
0000)
2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0.00=
0000), 4
2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
2021/09/15 08:49:50 socat[2215] D read -> 4
2021/09/15 08:49:50 socat[2215] D write(5, 0x55aa5f016000, 4)
Pop
2021/09/15 08:49:50 socat[2215] D write -> 4
2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 0 to 5
2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
2021/09/15 08:49:50 socat[2215] D read -> 4
2021/09/15 08:49:50 socat[2215] D write(1, 0x55aa5f016000, 4)
Pop
2021/09/15 08:49:50 socat[2215] D write -> 4
2021/09/15 08:49:50 socat[2215] I transferred 4 bytes from 5 to 1
2021/09/15 08:49:50 socat[2215] D data loop: sock1->eof=3D0, sock2->eof=3D=
0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
2021/09/15 08:49:50 socat[2215] D select(6, &0x21, &0x22, &0x0, NULL/0.00=
0000)
2021/09/15 08:49:50 socat[2215] D select -> (, 0x21, 0x22, 0x0, NULL/0.00=
0000), 4
2021/09/15 08:49:50 socat[2215] D read(0, 0x55aa5f016000, 8192)
2021/09/15 08:49:50 socat[2215] D read -> 0
2021/09/15 08:49:50 socat[2215] D read(5, 0x55aa5f016000, 8192)
2021/09/15 08:49:50 socat[2215] D read -> 0
2021/09/15 08:49:50 socat[2215] N socket 1 (fd 0) is at EOF
2021/09/15 08:49:50 socat[2215] I shutdown(5, 1)
2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
2021/09/15 08:49:50 socat[2215] N socket 2 (fd 5) is at EOF
2021/09/15 08:49:50 socat[2215] I shutdown(5, 2)
2021/09/15 08:49:50 socat[2215] D shutdown()  -> 0
2021/09/15 08:49:50 socat[2215] N exiting with status 0
2021/09/15 08:49:50 socat[2215] D exit(0)
2021/09/15 08:49:50 socat[2215] D starting xioexit()
2021/09/15 08:49:50 socat[2215] D finished xioexit()
uds-access RC=3D0
2021/09/15 08:49:52 socat[2240] D getpid()
2021/09/15 08:49:52 socat[2240] D getpid() -> 2240
2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PID", "2240", 1)
2021/09/15 08:49:52 socat[2240] D setenv() -> 0
2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_PPID", "2240", 1)
2021/09/15 08:49:52 socat[2240] D setenv() -> 0
2021/09/15 08:49:52 socat[2240] I socat by Gerhard Rieger and contributor=
s - see www.dest-unreach.org
2021/09/15 08:49:52 socat[2240] I This product includes software develope=
d by the OpenSSL Project for use in the OpenSSL Toolkit. (http://www.open=
ssl.org/)
2021/09/15 08:49:52 socat[2240] I This product includes software written =
by Tim Hudson (tjh@cryptsoft.com)
2021/09/15 08:49:52 socat[2240] D socat version 1.7.4.1 on Jan 27 2021 00=
:00:00
2021/09/15 08:49:52 socat[2240] D setenv("SOCAT_VERSION", "1.7.4.1", 1)
2021/09/15 08:49:52 socat[2240] D setenv() -> 0
2021/09/15 08:49:52 socat[2240] D running on Linux version #58 SMP Wed Se=
p 15 08:40:38 PDT 2021, release 5.15.0-rc1bisect, machine x86_64

2021/09/15 08:49:52 socat[2240] D argv[0]: "socat"
2021/09/15 08:49:52 socat[2240] D argv[1]: "-d"
2021/09/15 08:49:52 socat[2240] D argv[2]: "-d"
2021/09/15 08:49:52 socat[2240] D argv[3]: "-d"
2021/09/15 08:49:52 socat[2240] D argv[4]: "-d"
2021/09/15 08:49:52 socat[2240] D argv[5]: "-"
2021/09/15 08:49:52 socat[2240] D argv[6]: "UNIX-CONNECT:./targets/uds-no=
troot/uds-access-socket"
2021/09/15 08:49:52 socat[2240] D sigaction(1, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(2, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(3, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(4, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(6, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(7, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(8, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(11, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D sigaction(15, 0x7ffcca7e26c0, 0x0)
2021/09/15 08:49:52 socat[2240] D sigaction() -> 0
2021/09/15 08:49:52 socat[2240] D signal(13, 0x1)
2021/09/15 08:49:52 socat[2240] D signal() -> 0x0
2021/09/15 08:49:52 socat[2240] D atexit(0x560590a15110)
2021/09/15 08:49:52 socat[2240] D atexit() -> 0
2021/09/15 08:49:52 socat[2240] D xioopen("-")
2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e899d0
2021/09/15 08:49:52 socat[2240] D malloc(1024)
2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e89d30
2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8a140
2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8abc0
2021/09/15 08:49:52 socat[2240] D isatty(0)
2021/09/15 08:49:52 socat[2240] D isatty() -> 0
2021/09/15 08:49:52 socat[2240] D isatty(1)
2021/09/15 08:49:52 socat[2240] D isatty() -> 0
2021/09/15 08:49:52 socat[2240] D malloc(128)
2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af00
2021/09/15 08:49:52 socat[2240] D malloc(128)
2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8af90
2021/09/15 08:49:52 socat[2240] N reading from and writing to stdio
2021/09/15 08:49:52 socat[2240] D xioopen("UNIX-CONNECT:./targets/uds-not=
root/uds-access-socket")
2021/09/15 08:49:52 socat[2240] D calloc(1, 824)
2021/09/15 08:49:52 socat[2240] D calloc() -> 0x560591e8b020
2021/09/15 08:49:52 socat[2240] D malloc(1024)
2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b360
2021/09/15 08:49:52 socat[2240] D malloc(128)
2021/09/15 08:49:52 socat[2240] D malloc() -> 0x560591e8b770
2021/09/15 08:49:52 socat[2240] N opening connection to AF=3D1 "./targets=
/uds-notroot/uds-access-socket"
2021/09/15 08:49:52 socat[2240] D socket(1, 1, 0)
2021/09/15 08:49:52 socat[2240] I socket(1, 1, 0) -> 5
2021/09/15 08:49:52 socat[2240] D fcntl(5, 2, 1)
2021/09/15 08:49:52 socat[2240] D fcntl() -> 0
2021/09/15 08:49:52 socat[2240] D connect(5, {1,AF=3D1 "./targets/uds-not=
root/uds-access-socket"}, 41)
2021/09/15 08:49:52 socat[2240] D connect() -> 0
2021/09/15 08:49:52 socat[2240] D getsockname(5, 0x7ffcca7e20f0, 0x7ffcca=
7e20d4{112})
2021/09/15 08:49:52 socat[2240] D getsockname(, {AF=3D1 "<anon>"}, {2}) -=
> 0
2021/09/15 08:49:52 socat[2240] N successfully connected from local addre=
ss AF=3D1 "uds-notroot/ud\xEE\xEE\xEE\xEEcess-socket")\n"
2021/09/15 08:49:52 socat[2240] I resolved and opened all sock addresses
2021/09/15 08:49:52 socat[2240] D posix_memalign(0x7ffcca7e2698, 4096, 16=
385)
2021/09/15 08:49:52 socat[2240] D posix_memalign(...) -> 0
2021/09/15 08:49:52 socat[2240] N starting data transfer loop with FDs [0=
,1] and [5,5]
2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D0, sock2->eof=3D=
0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x22, &0x0, NULL/0.00=
0000)
2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x22, 0x0, NULL/0.000=
000), 3
2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
2021/09/15 08:49:52 socat[2240] D read -> 5
2021/09/15 08:49:52 socat[2240] D write(5, 0x560591e8c000, 5)
2021/09/15 08:49:52 socat[2240] D write -> 5
2021/09/15 08:49:52 socat[2240] I transferred 5 bytes from 0 to 5
2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D0, sock2->eof=3D=
0, closing=3D0, wasaction=3D1, total_to=3D{0.000000}
2021/09/15 08:49:52 socat[2240] D select(6, &0x21, &0x20, &0x0, NULL/0.00=
0000)
2021/09/15 08:49:52 socat[2240] D select -> (, 0x1, 0x20, 0x0, NULL/0.000=
000), 2
2021/09/15 08:49:52 socat[2240] D read(0, 0x560591e8c000, 8192)
2021/09/15 08:49:52 socat[2240] D read -> 0
2021/09/15 08:49:52 socat[2240] N socket 1 (fd 0) is at EOF
2021/09/15 08:49:52 socat[2240] I shutdown(5, 1)
2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
2021/09/15 08:49:52 socat[2240] D data loop: sock1->eof=3D3, sock2->eof=3D=
0, closing=3D1, wasaction=3D1, total_to=3D{0.000000}
2021/09/15 08:49:52 socat[2240] D select(6, &0x20, &0x0, &0x0, &0.500000)=

Snap
2021/09/15 08:49:52 socat[2240] D select -> (, 0x20, 0x0, 0x0, &0.500000)=
, 1
2021/09/15 08:49:52 socat[2240] D read(5, 0x560591e8c000, 8192)
2021/09/15 08:49:52 socat[2240] D read -> -1
2021/09/15 08:49:52 socat[2240] E read(5, 0x560591e8c000, 8192): Invalid =
argument
2021/09/15 08:49:52 socat[2240] N exit(1)
2021/09/15 08:49:52 socat[2240] D starting xioexit()
2021/09/15 08:49:52 socat[2240] I shutdown(5, 2)
2021/09/15 08:49:52 socat[2240] D shutdown()  -> 0
2021/09/15 08:49:52 socat[2240] D finished xioexit()
uds-access RC=3D1

=C2=A0


