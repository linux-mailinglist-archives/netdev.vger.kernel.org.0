Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6E517D811
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 03:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCICPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 22:15:17 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38381 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgCICPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 22:15:17 -0400
Received: by mail-io1-f65.google.com with SMTP id s24so7630113iog.5
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 19:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3AxSsH8NRlgJC5rPI+WaVRJCZenfHMUSGrIbXmfEZJk=;
        b=RHgKIWJLAtoPTb0SAGBl5nVCbXidEoBCxscRW6ENOyiO+mgPx/rQP+lGxLPp1WlhDG
         fg5/VbqPAS6HVnCKvQaCW30+6829VTstWqmBChw97/ZLvUT2z3tw8GpGIcCfcoMk3uls
         SvqC5NapTFMuMK+ijh3EV6r1OXBMelNTPFcKhmBhgERdjPr7KQs2hZ41eLGrmiDFdSdr
         N6EM/hMHK5dVsSKQZKT31OBDgQDJU7nwu4WzLEPsrvX8C/s1jPOz5yCmbwI5IIDaW+ty
         qNgLMEMEbJl6i4jSzmjo7l8yGJEEPAOr0NNV34ViH2LxCfXjHFEv/lATHNnAAnCmQTBf
         pYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3AxSsH8NRlgJC5rPI+WaVRJCZenfHMUSGrIbXmfEZJk=;
        b=ULNUMaW5DK/eKChF6TXEUt0m9bPZHVK7pzRoW77oBVxu0XBMdrhbAlKVR01Lt5RJ1q
         b/1eNtSpWfEDNOM/Huyap8TRZTIDkdvDFCTRBUlslh5sMusZUG9DPh3zm+8njMBHjCwl
         dmLLycCYXG8HkB36+e4N5uezoILo2ZdK9t/QRW68MbdpP2Vfm0aiFxNpvWySSMcIoNgh
         Gaz8NT/y1O9NU1NbJy+6tnFMo2Fxyt5WWLeDDbtdOb46XK8XbeZT6OV23w21fKLMh0QG
         LLF0RNOFIzH+tnNCzCvQDLE/XPZ3tMnT/pIu9inCcuM+r42A7tuoMM/3kzbxtOU2o24d
         ozRw==
X-Gm-Message-State: ANhLgQ0ZlCN3G+MZcTaz9zQr5JxOfusGxCTJ9sx2UkftUsnmpSLnX0+l
        4IvZQkKGcWLm3rLKxXV53nQ=
X-Google-Smtp-Source: ADFU+vs9mRGWuVIsWbPQgjzNXTc3lPOl/k79RJQplzFhHnThFIXogEFK1HjC8X9MC2hVAKgOeL4CcQ==
X-Received: by 2002:a6b:f913:: with SMTP id j19mr11548730iog.124.1583720116737;
        Sun, 08 Mar 2020 19:15:16 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:54d7:a956:162c:3e8? ([2601:282:803:7700:54d7:a956:162c:3e8])
        by smtp.googlemail.com with ESMTPSA id p189sm1717117iof.17.2020.03.08.19.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 19:15:15 -0700 (PDT)
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Alarig Le Lay <alarig@swordarmor.fr>
Cc:     netdev@vger.kernel.org, jack@basilfillan.uk,
        Vincent Bernat <bernat@debian.org>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
Date:   Sun, 8 Mar 2020 20:15:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/20 4:57 AM, Alarig Le Lay wrote:
> On sam.  7 mars 17:52:10 2020, David Ahern wrote:
>> On 3/5/20 1:17 AM, Alarig Le Lay wrote:
>> Kernel version?
> 
> I’ve seen this from 4.19 on my experience, it works at least until 4.15.
> 
>> you are monitoring neighbor states with 'ip monitor' or something else?
> 
> Yes, 'ip -ts monitor neigh' to be exact.
> 
>> The above does not reproduce for me on 5.6 or 4.19, and I would have
>> been really surprised if it had, so I have to question the git bisect
>> result.
> 
> My personal experience is that, while routing is activated (and having a
> full-view, I don’t have any soft router without it), the neighbors are
> flapping, thus causing a blackhole.
> It doesn’t happen with a limit traffic processing. The limit is around
> 20 Mbps from what I can see.

If you are using x86 based CPU you can do this:
    perf probe ip6_dst_alloc%return ret=%ax

    perf record -e probe:* -a -g -- sleep 10
    --> run this during the flapping

    perf script

this will show if the flapping is due to dst alloc failures.

Other things to try:
    perf probe ip6_dst_gc
    perf stat -e probe:* -a -I 1000
    --> will show calls/sec to running dst gc


    perf probe __ip6_rt_update_pmtu
    perf stat -e probe:* -a -I 1000
    --> will show calls/sec to mtu updating


    perf probe rt6_insert_exception
    perf state -e probe:* -a -I 1000
    --> shows calls/sec to inserting exceptions

(in each you can remove the previous probe using 'perf probe -d <name>'
or use -e <exact name> to only see data for the one event).

> I have the problem with 5.3 (proxmox 6), so unless FIB handling has been
> changed since then, I doubt that it will works, but I will try on
> Monday.
> 

a fair amount of changes went in through 5.4 including improvements to
neighbor handling. 5.4 (I think) also had changes around dumping the
route cache.
