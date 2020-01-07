Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE461132DEF
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgAGSFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:05:24 -0500
Received: from sonic306-27.consmr.mail.ne1.yahoo.com ([66.163.189.89]:41337
        "EHLO sonic306-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbgAGSFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578420320; bh=kgtFy8WugR27raH2RhqxJkgmbNIymSXHZjMYjVgl+wc=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=s44mSgRSmmeJnG1TV5PedQ91JzpQDI9rl9h36DmZdhvqxZXBdASkTzzfmr5O1LJgq97zlVh9nMINXAEFcHJQzGmlc+bl0nFWUFzuorsNSL3gY7uuIY0UCvgnGQQs0WX1cbSYKCBI9/az5JZWOpqS9hUsPtLn9b91SAA5OvdUPeUHjW1gwiesgJsTLSf93j3s/DMH1Ov93mBSsAYQGj1XeFu9xgjVKA0MTDa2+VDv73JtR8xU/oIIzG6P8rwcw42DpvbbN4EP5W14Jyghel/Baa/eOGACY2JsAa5ESe3qOUVayxShEQmS2SmzJCeqzC8NrSJ0X3tzQWuLyGsVRKkjBA==
X-YMail-OSG: VFbTb7YVM1kw0okK61w50ooc4DnGCtDpB944xRs8HBzgGXnDc.tABpip8P90sm_
 lTmkl7bB97xSpumW3gj2xBt40l8GZBir8hO8rinAgURNQTTzBStTs81oAr_ObQtBgZhf1D.bDz82
 RFfc7o4Cd8.JV0ETCNA8ykCoXoJH3BC0Z33fj4DA4GuzEidhVz912qCu2PDzcmBNc4ehK6Q3kO9S
 LugsZZ9P8GqXUcmXEN4QFe3x1UOo.weYVm2ghD1IXOYLvA0oM7ccfKL9M0E4RVYeHR7oEU1K8wXJ
 V95hq17deuSnRseqr6h0Kds9tRFlIT9dR96.MboMO1ZYwilPqisgxCJRqONPv_TZUt2ETEdosyAJ
 Um1zC55BaumHjue0Gx9b0BQlQItE5VrkgZ8xtaKtB89DhZYbs9A76g1wKUOqS5PtoWfY5ynBy51X
 dK2k.QRVX.rUaBVEPuwVSD3KBVneJ.Du2m06Cac7seaayL5IjqkQ0n_X.Od7Ojs2x4Bg8fWt.OvL
 VbhJ6PyiI.gxDnfsANe16cYeqp.4t.Yb0rlKuotLIPurPTGttKPlL7mv.k5T91mtgsU5iVSfNkF6
 f2O6HWhoMLelU0..NWe3znfXbOawd_Kr6Ewh4BU.P4XWgD6hNh1aYtuFshD4ghZOKUwK2d6q94Vw
 wu4K_aGoVQoeLyMqRuYqE9XuYOaTz4eOyVoFXFWNABUDnLYBLYocLg.pXH3Kl_o5W2COzunRaob8
 _UDiZMR.dWnpuEzYz.DfYWV0Oz1oColei1BsZp1vY9HW8g5HGOYUhbkgG7FZUo4WHem5jlx3rS53
 Z1dQoEWm19PNCXn3YSJfEp.UfTN_FC9M0SDL52x6mKz3zVLkxBnaZ1XZDahtWJwphDuCp2VJPU.z
 vbKR0fMcFzO_sHC.T8Xz_NygGU6mBOhPgHAqQZBsNnW7UAJaNfTTob6Fg822izSiTi5L76A3Ic6N
 JhRbYF3Wub5Z5h.rLqK8YuZeYR35072_dPB7kaSAMmuTFPOO1iQgQj35KFohAgI5QvEmb8eZDQzN
 ztufKTE8sjK_9sM77daDfZd.KCxZ4yE5LH6mk73_MQQqrq2MB98cmh5FoOulvJ20rIXs6rKBTYNR
 MG8bRIG_15OHmqsKCBRgE.bCZYb9AmV0m2o7FtOQjt6hRvavPcmnQ2aTpJGnwWDniL7pKMkA5uw9
 twWB1T9c0hCBvR8ZfCIMARZWMLn0qQaYV3YbbSSiLLK9e6aLQ8478Ww.dNO3u6kiUN0cHGDTPFc_
 3uhcKAIu4EZs2ZZ7lUjyGB1BKdlbl4p_zOmr9M2PsKjjNoHAb_kDy2z6..KXocN9YROk.Lysge29
 yAhJpwIcDDAe_8hAvZ2PEMjGKpl9_Lumg.F3o2YIhwexRFfXQ9gu4TNEUEFZttGZ4GQ_k5r64i47
 TNTBayFah77uNAuZHnbPwwlBOPByNfRDu38JQ
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 7 Jan 2020 18:05:20 +0000
Received: by smtp416.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 58f909077385df327a6999437f360e3f;
          Tue, 07 Jan 2020 18:05:18 +0000 (UTC)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Ahern <dsahern@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <ba512c8a-d8aa-c344-f38f-47d396bbf655@schaufler-ca.com>
Date:   Tue, 7 Jan 2020 10:05:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.14873 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2020 1:03 PM, Tetsuo Handa wrote:
> On 2020/01/07 1:41, David Ahern wrote:
>>>>  #ifdef SMACK_IPV6_SECMARK_LABELING
>>>>                 rsp = smack_ipv6host_label(sip);
>>>>
>>>>
>>>> ie., if the socket family is AF_INET6 the address length should be an
>>>> IPv6 address. The family in the sockaddr is not as important.
>>>>
>>> Commit b9ef5513c99b was wrong, but we need to also fix commit c673944347ed ?
>>>
>> not sure. I have not seen a problem related to it yet.
>>
> A sample program shown below is expected to return 0.
> Casey, what does smack wants to do for IPv4 address on IPv6 socket case?

Thank you, this program has been very helpful. The problematic
checks are supposed to be simply for data sanity, not security.
I think I've got the right set of checks figured out. I'll send
a patch for review once it tests out.

>
> ----------
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <sys/un.h>
> #include <arpa/inet.h>
> #include <unistd.h>
>
> int main(int argc, char *argv[])
> {
>         const int fd1 = socket(PF_INET6, SOCK_DGRAM, 0);
>         const int fd2 = socket(PF_INET, SOCK_DGRAM, 0);
>         struct sockaddr_in addr1 = {
>                 .sin_family = AF_INET,
>                 .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
>                 .sin_port = htons(10000)
>         };
>         struct sockaddr_in addr2 = { };
>         char c = 0;
>         struct iovec iov1 = { "", 1 };
>         struct iovec iov2 = { &c, 1 };
>         const struct msghdr msg1 = {
>                 .msg_iov = &iov1,
>                 .msg_iovlen = 1,
>                 .msg_name = &addr1,
>                 .msg_namelen = sizeof(addr1)
>         };
>         struct msghdr msg2 = {
>                 .msg_iov = &iov2,
>                 .msg_iovlen = 1,
>                 .msg_name = &addr2,
>                 .msg_namelen = sizeof(addr2)
>         };
>         if (bind(fd2, (struct sockaddr *) &addr1, sizeof(addr1)))
>                 return 1;
>         if (sendmsg(fd1, &msg1, 0) != 1 || recvmsg(fd2, &msg2, 0) != 1)
>                 return 1;
>         if (connect(fd1, (struct sockaddr *) &addr1, sizeof(addr1)))
>                 return 1;
>         if (send(fd1, "", 1, 0) != 1 || recv(fd2, &c, 1, 0) != 1)
>                 return 1;
>         return 0;
> }
> ----------
