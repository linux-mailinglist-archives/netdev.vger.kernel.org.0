Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040C4D694D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388750AbfJNSRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:17:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42388 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731926AbfJNSRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:17:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id n14so20770086wrw.9;
        Mon, 14 Oct 2019 11:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Iz1oz6GP5HGCChUa1AGUpZ/JU9QpdTHhqE0pdx1Qug=;
        b=iSrKUWwaTP9uGmXMsO0BtAW8cJOduQ5JTliCmr6bkUSxDkRbcjjoNg2s8b2Mmi8CtE
         WFn8uVIwhghntOhnc6CbbUilCpUnPSLx0vL7t+YzdYwSTTe7WVyn+NYJKP3Y69i3amxT
         6w8n7KbghojZ4VouDbJnHGOjNdZGvP+GvrRGNQNWIpFmS2bHg/gRCNw1EkJceuJRN/GA
         oIFq0wMxihYf2qus2L+q83XksWrBArXepLY0xhD30kbNxcKyYvdeNQ1CVGDYoSrfkpBc
         coJPMOxQIQ05OsxU+4bkKvHM8TsxCz9rXFmhN8Hkbf9J4zdJFkNTOlccFzlVnGujVA/9
         Bzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Iz1oz6GP5HGCChUa1AGUpZ/JU9QpdTHhqE0pdx1Qug=;
        b=QKiJjQZbSPmWxDSFBmWqlRdOjNvPFc1a3JCa4P+K+nLxihcFIbNtfSmi9I40ybpHg5
         N/aGc1um+Pm8107Shzpal5lP0vCi9zO+W9SL0m90pkJng1rs2+shT16v4ZcXXDmNFRQ/
         syYpVsVuYN9yeK8UoHKoyPCiEM206ztVFI7++7S2ifJmiY4GO+isuzKsTXVYIoDylLaO
         p2UhJhDAZTxshif3Rx12IsWlSzPHAwr56vUr4vN8alDJShWUbzG3IE+6RGpX1Mxe3SB6
         ayTg028AFyZb2E1d7wLlqTEf6vvIFDHNmI4vwosMQtzyUQFrXBjfVb3jW58OVyuoE7Hv
         Pe1A==
X-Gm-Message-State: APjAAAXD5R/uPlUbvpfvNBnlEVcnYqwJQ4pxkQa9v8nQ4G76Qjp16slo
        U33E8uz6anRRLULWrz5hKx0=
X-Google-Smtp-Source: APXvYqwzDmZVXGHklV4WahIEDJl6sJwwyx+JzyCH7C4cgz1/xOYpjceBxm0ni/Rv+Au96vTfE1+GDg==
X-Received: by 2002:a5d:558b:: with SMTP id i11mr15233487wrv.166.1571077017345;
        Mon, 14 Oct 2019 11:16:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ed5d:7e31:897c:be08? ([2003:ea:8f26:6400:ed5d:7e31:897c:be08])
        by smtp.googlemail.com with ESMTPSA id o22sm45046855wra.96.2019.10.14.11.16.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 11:16:56 -0700 (PDT)
Subject: Re: Module loading problem since 5.3
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <8132cf72-0ae1-48ae-51fb-1a01cf00c693@gmail.com>
 <CAB=NE6XdVXMnq7pgmXxv4Qicu7=xrtQC-b2sXAfVxiAq68NMKg@mail.gmail.com>
 <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
 <20191014100143.GA6525@linux-8ccs>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <dbeb6e00-bc8f-e3ed-5a1c-57eace6dee17@gmail.com>
Date:   Mon, 14 Oct 2019 20:16:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014100143.GA6525@linux-8ccs>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.10.2019 12:01, Jessica Yu wrote:
> +++ Heiner Kallweit [11/10/19 21:26 +0200]:
>> On 10.10.2019 19:15, Luis Chamberlain wrote:
>>>
>>>
>>> On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>>>
>>>        MODULE_SOFTDEP("pre: realtek")
>>>
>>>     Are you aware of any current issues with module loading
>>>     that could cause this problem?
>>>
>>>
>>> Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
>>>
>>> If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
>>>
>>>   Luis
>>>
>> Maybe issue is related to a bug in introduction of symbol namespaces, see here:
>> https://lkml.org/lkml/2019/10/11/659
> 
> If you're running into depmod and module loading issues with kernels >=5.3-rc1,
> it's likely due to the namespaces patchset and we're working on
> getting all the kinks fixed. Could you please ask the bug reporter to
> try the latest -rc kernel with these set of fixes applied on top?
> 
>   https://lore.kernel.org/linux-modules/20191010151443.7399-1-maennich@google.com/
> 
> They fix a known depmod issue caused by our __ksymtab naming scheme,
> which is being reverted in favor of extracting the namespace from
> __kstrtabns and __ksymtab_strings. These fixes will be in by -rc4.
> 
Thanks a lot, I'll check with the affected users.
Maybe worth to be noted: I wasn't able to reproduce the module loading issue
on my systems, one difference is that affected users have kmod utils
version 25 and I have version 26. I asked them to upgrade to v26 and re-test,
feedback is pending.

> Thanks,
> 
> Jessica
> 
> 
> .
> 
Heiner
