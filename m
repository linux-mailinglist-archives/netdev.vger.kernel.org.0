Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633CE9A13C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393280AbfHVUfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:35:06 -0400
Received: from sonic312-30.consmr.mail.gq1.yahoo.com ([98.137.69.211]:35025
        "EHLO sonic312-30.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388336AbfHVUfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566506104; bh=AXDeSoHVUdpZIReewPIIhnNh7qa1BVf2M85qYVqLMow=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=E2cPkhLgtF5QoOjCPivmyaCoNs+3s5H3vqKr1wXEjD1nDXfPwVISHkSRPajIqGQeOwsubX+Mr84jYK17huSUbzTw0MD4BSS5FJ9PfbC9ld2jdkuKn6PEqHVKsBBnzxlvUMhaDtOgnP3xBe+ZHakFcLiv66TsMjytZgLmqg/RvG17cymgUZuX2d2LmkDM8NECnrXotaYVBPoLwn2jLBe5CVwmw86qDoX0U+lDV5shbWcO1uUOxedFadUNqvFl/m858Le8PNoPICeiIV+6YxExbEy4n4wNBqXsBIHPvgWV6r/dzn0KvxZzM7BokODVgMzV4auKppedRsy1xHWfqOygPA==
X-YMail-OSG: eM2gFZ8VM1k3DYS7.TrK5w.2xlAqkaWhH9dYWfK9iIF4ajQAEcynlN8aznYavUy
 mh6b3DilZ3dzlbibGrh1JH13d_ypX3g0imwk_kgKAbrSmEajriTGp885lH3jKEmGdmWqaoThpIQM
 FD8IbCPhU32HoZJJo8Lwr4s33BVCFI4HvEXuHpX.ouyU1.LzzmDvDD8lloYucBmgskJdhzbSqKux
 1U2KtOgiCd3230mfj35sZwSL_NHUYz6pZc4pi84PU8JStk6DB3jp79s_WekNJiqMDKojUrtSJfG.
 ICvSCerJjKvrnIXO.sQmXXlidbJbndYak_U5mdPkrVsxpYG3tbhlTmO0nQSqansYJBsFLLj1vsV3
 hnT00xkzAq6LezGPQPmcmH2NZANBClrxgnwWOrwi2HnafEkudgjd5peZ1_GSOo_EWpdX3ZqlSIun
 .Itbaa78_qTh8QjhqiK8GtHu0qngVALZHnP1gtOBFgm88ZVd9JlTV7uARBWVEJ6QvcGVbnUNjPQ.
 J3ALz3yN92zTTbl64AS8zZE212GMW8qb4ADJrNhyhRHSlxoclne3e.5GbFoMTy317XLFKDlOQoe1
 STXVKG0xZpLFfYe0JNH7HQdTc.zNvqcX3M0qimCMVBf61C_gGLEWral8c09gravESj_WcVBgnvjN
 neD8j.ccySlSmDHOEV9LilLH8XztF2f1FFNN6HvQ86M45d.f65UeIIQccMKassINz3zhPyLlbw5V
 _VbyzeyjQ4lSUXKk8TBlppepxiyBM26REPQzwtBWkc7TSQN2V4ja6i5xTlxoNAkefAf4dmFG1zsO
 4nnyFAwxLChOklHBoCD6K6tGxwVbyHnfGRgOCKb_j5JFcCvYZI9sUd7RpdT1hL6nXFEH_F_ZWkw9
 vWEa3rUn7qWsW3RmtEcH6vDpt_c7ipc5MK2uflBRj27S_7RvFLVTpg2Resg6TJtFlK6lnli4laN7
 cZ0oB7m6JbSwpJQ1RFoMumr5m59SSyXqrg.vgkWBwXEKdXi_Jyi.opcU3x7p5lQ_bXbOLphvbXqa
 27QHr74FrGOXXznm9IHZg2iTYYnjFrJu29LYhxfqD0vyySS.q.oMS1U62RyVykIG.u1diKO0XY7m
 J85Ui0HFg2WdsH9TzH8FPVunddlVtB5KoRlQEcbbCwwHTufqMQqM37R7Ay8M.JmQw4DCLlQOQrgq
 Lks3b6qOmnLrPMrF3YFvzaDj86C3giDlz02UZgN11UJEUuH8t7xLNpi1qXTEz1Ae5D.bkOt54tXi
 pV4w5WaP8AwQQ2VXaBwAGgA1.vFzFGQij7Jn5oO98sWbk9rFkJGw5Z1_y1xMbvHrWDV8-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Aug 2019 20:35:04 +0000
Received: by smtp423.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 9f8ba66eae99fabf59fa4846f0e1b0bb;
          Thu, 22 Aug 2019 20:35:00 +0000 (UTC)
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     Florian Westphal <fw@strlen.de>
Cc:     Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
 <20190822070358.GE20113@breakpoint.cc>
 <CAHC9VhQ_+3ywPu0QRzP3cSgPH2i9Br994wJttp-yXy2GA4FrNg@mail.gmail.com>
 <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
 <20190822201520.GJ20113@breakpoint.cc>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <32646e98-2ed6-a63a-5589-fefd57e85f66@schaufler-ca.com>
Date:   Thu, 22 Aug 2019 13:35:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822201520.GJ20113@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2019 1:15 PM, Florian Westphal wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>> Given that the original objection to using a skb extension for a
>> security blob was that an extension is dynamic, and that the ubiquitou=
s
>> nature of LSM use makes that unreasonable, it would seem that supporti=
ng
>> the security blob as a basic part if the skb would be the obvious and
>> correct solution. If the normal case is that there is an LSM that woul=
d
>> befit from the native (unextended) support of a blob, it would seem
>> that that is the case that should be optimized.
> What is this "blob"? i.e., what would you like to add to sk_buff to mak=
e
> whatever use cases you have in mind work?

In LSM terminology a blob is a set of data managed and used by
the LSM (either in the infrastructure or the security module).
Blob pointers are included in the system data structures to which
they relate. The inode has an i_security field, which is a void *.
If the secmark where replaced by a security blob, the u32 secmark field
in an sk_buff would be replaced by a void * security field.


