Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1E78CFDD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHNJmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:42:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33789 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfHNJmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:42:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id p77so2926603wme.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 02:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1LMH6SXIr4y3OeSCEhgpBBRnkoJ/iF4yug5E7qmIcM8=;
        b=jST2oyZPt+7cx/dNQMmIPRJPW2b32lQYuArGcEStiShyulRW7nzit2GlkN4YiVDWUZ
         K79InC5iHoQ3i0U78JaVoNfTnFTLZOXpUm4QhIRIU03783sY5rQHrnZI+liDJujnA8Xf
         t4zVNdSe/cpQa0lTMKuz3+0mdg9VhkUzZWLQ6jDPyjxwF1bYqL/1oOFiGKMCF0/Smgze
         kv33fTJP88SLvQ5ILXf7W4ns48zrZUd5dTktZdQ5FBjNDNIc8L5i2ZC3mSLiBjYXGnl8
         E6nLtFyNejUGLezcFxTqeGO3bcOTg0v5S+MSwhy5SxLicjTh2+mrEnLIzvjEuBM5lXqQ
         fouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1LMH6SXIr4y3OeSCEhgpBBRnkoJ/iF4yug5E7qmIcM8=;
        b=ZHKFJt7rNQipodvHolg+i96C3boYxI0y5OiKU7TApCj3hqF4zGDCmICNaDq3UcNRYf
         GZSOWY9O+oIVsmrPI6JnEfTfioHsJCH1gqmDTWJDqjFAC6ukPO6HTett8rqEex/GZeF2
         Q076HvohXx5Aq4/y1MAdITpBXm4wGRPo4ksmiSSRN4VDc+oJhqqmGlwX4HPxPaqRkDdj
         iWyGbCIE2jPYV77S1T90EWlB9px3EYLbbtNVqMDeQ09m0LoQQkXuOuecoESN5UDZ8I3y
         PjA27gWerYMn3fLF/VbSRYAiOYP/dvhXAJBtHxUQ81cTJwfjCE29TJH+jX8hMoRXeZU+
         6Org==
X-Gm-Message-State: APjAAAWyeWlTFCjqaW+A6XtIzyLTo1oKygt3nUQogSm9BseO0qpWgPDI
        dNQK9JX+9vNEsldzUm3ZWo6mOw==
X-Google-Smtp-Source: APXvYqyDVzXUdyxfSnR9BJByvI9Q1QgjkoDw6pcuxy8rnNIvCq+9Wg7Rl6NMWxRDI5v54rSTR+aQJA==
X-Received: by 2002:a1c:7e85:: with SMTP id z127mr7646079wmc.95.1565775726660;
        Wed, 14 Aug 2019 02:42:06 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id v10sm2817439wmc.11.2019.08.14.02.42.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 02:42:06 -0700 (PDT)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map
 entries
Message-ID: <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
Date:   Wed, 14 Aug 2019 10:42:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-13 18:51 UTC-0700 ~ Alexei Starovoitov
<alexei.starovoitov@gmail.com>
> On Tue, Aug 13, 2019 at 02:09:18PM +0100, Quentin Monnet wrote:
>> This series adds a "bpftool map count" subcommand to count the number of
>> entries present in a BPF map. This results from a customer request for a
>> tool to count the number of entries in BPF maps used in production (for
>> example, to know how many free entries are left in a given map).
>>
>> The first two commits actually contain some clean-up in preparation for the
>> new subcommand.
>>
>> The third commit adds the new subcommand. Because what data should count as
>> an entry is not entirely clear for all map types, we actually dump several
>> counters, and leave it to the users to interpret the values.
>>
>> Sending as a RFC because I'm looking for feedback on the approach. Is
>> printing several values the good thing to do? Also, note that some map
>> types such as queue/stack maps do not support any type of counting, this
>> would need to be implemented in the kernel I believe.
>>
>> More generally, we have a use case where (hash) maps are under pressure
>> (many additions/deletions from the BPF program), and counting the entries
>> by iterating other the different keys is not at all reliable. Would that
>> make sense to add a new bpf() subcommand to count the entries on the kernel
>> side instead of cycling over the entries in bpftool? If so, we would need
>> to agree on what makes an entry for each kind of map.
> 
> I don't mind new bpftool sub-command, but against adding kernel interface.
> Can you elaborate what is the actual use case?

Hi Alexei, thanks for your feedback.

The use case is a network processing application (close to a NAT), where
a hash map is used to keep track of flows, many of them being
short-lived. The BPF program spends a good chunk of time adding and
deleting entries to/from the map. The overall size (number of entries)
increases slowly, and when it grows past a certain threshold some action
must be taken (some flows are deleted from user space, possibly copied
to another map or whatever) to ensure we still have some room for new
incoming flows.

> The same can be achieved by 'bpftool map dump|grep key|wc -l', no?

To some extent (with subtleties for some other map types); and we use a
similar command line as a workaround for now. But because of the rate of
inserts/deletes in the map, the process often reports a number higher
than the max number of entries (we observed up to ~750k when max_entries
is 500k), even is the map is only half-full on average during the count.
On the worst case (though not frequent), an entry is deleted just before
we get the next key from it, and iteration starts all over again. This
is not reliable to determine how much space is left in the map.

I cannot see a solution that would provide a more accurate count from
user space, when the map is under pressure?

> 
>> Note that we are also facing similar issues for purging map from their
>> entries (deleting all entries at once). We can iterate on the keys and
>> delete elements one by one, but this is very inefficient when entries are
>> being added/removed in parallel from the BPF program, and having another
>> dedicated command accessible from the bpf() system call might help here as
>> well.
> 
> I think that fits into the batch processing of map commands discussion.
> 

This is also what we do at the moment, but we hit similar limitations
when iterating over the keys.

Thanks,
Quentin
