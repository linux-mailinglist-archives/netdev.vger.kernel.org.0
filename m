Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EA62DFA7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfE2OYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:24:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46855 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfE2OYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:24:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id r7so1909080wrr.13
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 07:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jeFoPgYQ+R4Vhp0W1imKmURk6lced8f6qWNQ25YNVGs=;
        b=cp6a3tqyXbLf6wwmgYYUzK5wZw5r/wzgvGkOfRwg3mBFP4Qp+wmCq79rECiTlnR1Ub
         i0MclZSmarpZ+YAIsF1XriPGwLNFM1BRmZ1Bz3HakwDbG/EUytzcgK8pyYa+/Zls4YHA
         SIGdzzRFE4Z6qCiY+FwcXWv51hs/mS36fIy3gDvRNCOCGv3IEGDB21I5NjAZ7vGuIiL1
         2fgB3QUHSzPCSwffoV5xXTSFTQ/Uvo9VrSExJNiU8WThJaWsffNx+AHkutWg+O33m/wY
         h1rvvVNZGv+75fJhyzaw+u6aezDHyfgV6S7HZshvGMefeWWfj8O7iO0StFrHTncYDLm1
         xthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jeFoPgYQ+R4Vhp0W1imKmURk6lced8f6qWNQ25YNVGs=;
        b=bHLmUioGCpZTisdJXoTNlhz5TMdDoeSl+ZUrrcEn7Uou2sw3InBBaouXeLOUu6HSG3
         04CfN7tPHR8AyhCQ9PCqDQrKOXiPMy+/mOwJg3+pPsKkp43S1J/c2lU0VZcHCEfw8mQx
         5jgWw69Y0ijypGs+V3tnqMwA1svcqS3XnK4vPc4I50xLxl/ddJC5tAYpcHDxpni2WKGM
         kIed38nMxQILOZYEY6DxYDdjcTJVV+Wsmhg3wC3eCPq72NDhT4xMDtSB8SZAxELtzl39
         BeKINykZdEEAwYWLErwv+YgYfksVnd7gMlZFZtKZOZiAZ5DGycMQOSexONHUhlSJbpHt
         DNTQ==
X-Gm-Message-State: APjAAAXap2W/B0gNrbnD2Qy0hpC5+LjEpp/1/0V0GbqZ3mQTKpH+B/Oh
        848qOyAYMzTGXplGqh61cSA5wA==
X-Google-Smtp-Source: APXvYqzcsJNOnbXcbSx9xW239pQVSsuKv0JOKeLPWoZ7+u5Iy3l8/GZXmocQJ9HaD69QhuMfKiJpyA==
X-Received: by 2002:a5d:5542:: with SMTP id g2mr9096614wrw.232.1559139886406;
        Wed, 29 May 2019 07:24:46 -0700 (PDT)
Received: from [172.20.1.104] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id c18sm21124587wrm.7.2019.05.29.07.24.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 07:24:45 -0700 (PDT)
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190529092323.27477-1-quentin.monnet@netronome.com>
 <1f3cfd61-f8af-f67e-aa2e-c0286df72820@iogearbox.net>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [oss-drivers] Re: [PATCH bpf-next] libbpf: prevent overwriting of
 log_level in bpf_object__load_progs()
Message-ID: <62254511-4afd-a66b-63c3-0bfa7738a571@netronome.com>
Date:   Wed, 29 May 2019 15:24:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1f3cfd61-f8af-f67e-aa2e-c0286df72820@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-29 16:03 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
> On 05/29/2019 11:23 AM, Quentin Monnet wrote:
>> There are two functions in libbpf that support passing a log_level
>> parameter for the verifier for loading programs:
>> bpf_object__load_xattr() and bpf_load_program_xattr(). Both accept an
>> attribute object containing the log_level, and apply it to the programs
>> to load.
>>
>> It turns out that to effectively load the programs, the latter function
>> eventually relies on the former. This was not taken into account when
>> adding support for log_level in bpf_object__load_xattr(), and the
>> log_level passed to bpf_load_program_xattr() later gets overwritten with
>> a zero value, thus disabling verifier logs for the program in all cases:
>>
>> bpf_load_program_xattr()             // prog.log_level = N;
> 
> I'm confused with your commit message. How can bpf_load_program_xattr()
> make sense here, this is the one doing the bpf syscall. Do you mean to
> say bpf_prog_load_xattr()? Because this one sets prog->log_level = attr->log_level
> and calls bpf_object__load() which in turn does bpf_object__load_xattr()
> with an attr that has attr->log_level of 0 such that bpf_object__load_progs()
> then overrides it. Unless I'm not missing something, please fix up this
> description properly and resubmit.

Ugh. Yeah, I mixed up bpf_load_program_xattr() and bpf_prog_load_xattr()
in the log, should be bpf_prog_load_xattr() everywhere instead, just as
you say. Apologies, I'll fix and resubmit.

Thanks,
Quentin
