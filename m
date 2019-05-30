Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823A430325
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE3UMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:12:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38989 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3UL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:11:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so4536322wma.4
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 13:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Jk75FVcR69V05SN1mYqY/qJT3B3cWtnlO+MIL3iYbzc=;
        b=SP5rLDLDJKOUBdw7NaAyEq80mS9yVnBbqv+LDc+ulp2dyLgvN64EAJxODSpY68ePLA
         Krykxt9UIk2BQBAtBqNrAGX6Y1Y1jTnWaCwzyAPFKjjCamDa5zFuaHTG3eVe59eJf3cE
         Xzd5PLVVqiOuy4kmKEldqK12SKtrFOOa//WTIMDedZGXc50w3QPhwTkG5LDyeUTxM5uH
         S/TArgl9xaiT9djJW0cJfS2B1jViugsJ+xRVo+8M7rNtq0rnB8W6smIBcl4BDE/rCT8W
         M5axAF/8Tf/Cy4udz3Xiq9bXTTaPwF19wmp8BC3+YU4mV499ok5TUkQuGE3OsRkWkbGb
         EWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Jk75FVcR69V05SN1mYqY/qJT3B3cWtnlO+MIL3iYbzc=;
        b=FHE8fMIgdowRKpo4pjV7ChTVrPAd+E5lTO+v2rXMtbkzCijzZL85wRcdaxLF93kBpg
         zKiAr0X4dy62aBDsQUF3GV/yGU//hAD05HbNRoSq7rPvN9C5EAUCoobuUTEksfamyhWC
         NSpi9KkWMVNMgZOK6VpluvgYp1SWjzOJfZBtVCUkmUmVomCnLkYCu1UE9v90FY07LxXI
         HONrmqr35+b7HrqDXLgoRHNw+TkdKtPDJ4fw42KSH0V+NzWMhIcuJqrwNoig13DjEOQ/
         5ETNPj9HWPqEwiOtZUPk9dcoo4KpOtEzzpggB5Z9i2hXFu0qBlUWtxQUU5Rc03F2tIER
         VuOw==
X-Gm-Message-State: APjAAAWQONfsY3uVjm29IFLXvOTGcdh5YeXVfOKCBk3ilQ/iZnxoL6Zr
        bpTPXODJy1g+I67GkRi6Q/AKiQ==
X-Google-Smtp-Source: APXvYqzX46mq4DxToktHvaK7AcLq+XHN33kKXU/CqOusf+bwbz8NDpScbMYuLYbEAxq8oBEnzELmuA==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr3479314wmc.130.1559247116638;
        Thu, 30 May 2019 13:11:56 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL (cpc1-cmbg19-2-0-cust104.5-4.cable.virginm.net. [82.27.180.105])
        by smtp.gmail.com with ESMTPSA id o20sm7381771wro.2.2019.05.30.13.11.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 13:11:55 -0700 (PDT)
References: <1559202287-15553-1-git-send-email-jiong.wang@netronome.com> <CAPhsuW4cFacLYAF1=8sG3gxu-g+Rzz6ySaFeBmL-sttxLZZLHw@mail.gmail.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Subject: Re: [PATCH bpf-next] bpf: doc: update answer for 32-bit subregister question
In-reply-to: <CAPhsuW4cFacLYAF1=8sG3gxu-g+Rzz6ySaFeBmL-sttxLZZLHw@mail.gmail.com>
Date:   Thu, 30 May 2019 21:11:51 +0100
Message-ID: <87pnnzpurc.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Song Liu writes:

> On Thu, May 30, 2019 at 12:46 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>> There has been quite a few progress around the two steps mentioned in the
>> answer to the following question:
>>
>>   Q: BPF 32-bit subregister requirements
>>
>> This patch updates the answer to reflect what has been done.
>>
>> v1:
>>  - Integrated rephrase from Quentin and Jakub.
>>
>> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  Documentation/bpf/bpf_design_QA.rst | 30 +++++++++++++++++++++++++-----
>>  1 file changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
>> index cb402c5..5092a2a 100644
>> --- a/Documentation/bpf/bpf_design_QA.rst
>> +++ b/Documentation/bpf/bpf_design_QA.rst
>> @@ -172,11 +172,31 @@ registers which makes BPF inefficient virtual machine for 32-bit
>>  CPU architectures and 32-bit HW accelerators. Can true 32-bit registers
>>  be added to BPF in the future?
>>
>> -A: NO. The first thing to improve performance on 32-bit archs is to teach
>> -LLVM to generate code that uses 32-bit subregisters. Then second step
>> -is to teach verifier to mark operations where zero-ing upper bits
>> -is unnecessary. Then JITs can take advantage of those markings and
>> -drastically reduce size of generated code and improve performance.
>> +A: NO
>
> Add period "."?

Ack

>
>> +
>> +But some optimizations on zero-ing the upper 32 bits for BPF registers are
>> +available, and can be leveraged to improve the performance of JIT compilers
>> +for 32-bit architectures.
>
> I guess it should be "improve the performance of JITed BPF programs for 32-bit
> architectures"?

Ack, that is more accurate.

Will respin.

Thanks.

Regards,
Jiong

>
> Thanks,
> Song
>
>> +
>> +Starting with version 7, LLVM is able to generate instructions that operate
>> +on 32-bit subregisters, provided the option -mattr=+alu32 is passed for
>> +compiling a program. Furthermore, the verifier can now mark the
>> +instructions for which zero-ing the upper bits of the destination register
>> +is required, and insert an explicit zero-extension (zext) instruction
>> +(a mov32 variant). This means that for architectures without zext hardware
>> +support, the JIT back-ends do not need to clear the upper bits for
>> +subregisters written by alu32 instructions or narrow loads. Instead, the
>> +back-ends simply need to support code generation for that mov32 variant,
>> +and to overwrite bpf_jit_needs_zext() to make it return "true" (in order to
>> +enable zext insertion in the verifier).
>> +
>> +Note that it is possible for a JIT back-end to have partial hardware
>> +support for zext. In that case, if verifier zext insertion is enabled,
>> +it could lead to the insertion of unnecessary zext instructions. Such
>> +instructions could be removed by creating a simple peephole inside the JIT
>> +back-end: if one instruction has hardware support for zext and if the next
>> +instruction is an explicit zext, then the latter can be skipped when doing
>> +the code generation.
>>
>>  Q: Does BPF have a stable ABI?
>>  ------------------------------
>> --
>> 2.7.4
>>

