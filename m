Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821E81EE7DE
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 17:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgFDPeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 11:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbgFDPem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 11:34:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F96EC08C5C0;
        Thu,  4 Jun 2020 08:34:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p5so6586897wrw.9;
        Thu, 04 Jun 2020 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D3By0h98qnolfLM0+QRpl2dqCpgdvgnNY+OucjDnKDY=;
        b=vZt0DMCfoJUEXzeTrBICKPyqGfuBe7vx1mxfTRfe7AMZfEO9MgZiR1mPQATjGg7sos
         L2gEppsjZRToGPjruQDj6PgcZ9k1LIUGD0iWIyOtnINMSac6a+7rCj3z4QC4lrZCdKFE
         k2yM8OXoWQeV2IMPxu2sJJA6xUKeMYmYvndml0HnOewX3ksq8F1r9goi9s79mQpwsSIb
         c5mAXaNTKzUmdLKel6x7irCbEI4DTv2oXtv/qN7Oxn1zzp0W/r8QazRbJWdm+blAf/6N
         mqCzGRjWNAgSpkjxibd5bm0M9tIZAW+bPd5JKLWcPAMtTD2J+9FPsJ68L+Qr8Bw98u2/
         uiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D3By0h98qnolfLM0+QRpl2dqCpgdvgnNY+OucjDnKDY=;
        b=JZ8eG8tE4Lrj45800Q9lSdVl1iphQ/O0A/WBiZSX/qfUZrp9kuz9mx7Aas4wk9Cz2t
         YOyhEGAOox3UiNgIhxGiEAdmW7/I6HpNeqd3ac3pf7rNg0bQSMSYM2OoJx6UDo0UrMhT
         IODk77ghGzgKxAftTjwQDWJZcTMSBxjDQtlOKmdYnIHBeNr7DuFOpkeRD5sNTnD7QDMW
         c66hlInF0eD4sknRVCkMOquRbw11MXQ6XFqsX+FDPbfLLc9Ix6P21O0X9JkCpZuCNoQ8
         cMzt5mI8yG+KHkq896a/kZcL3/uZ/Pf1OayiCs2sbzNkK7lddWbrIhuV6t1jFQ1bFWE7
         GH+w==
X-Gm-Message-State: AOAM531sL81mAp0DcxfV/kkabS5Uu5LKAFtK6gzhHQqXxIpKx19EmvSx
        J6WaYub0DBy0Omn3nc9kPcKtaZmjiMY=
X-Google-Smtp-Source: ABdhPJxfqtpJqbRTF++Qa4Ke2KxsNtWe0xpkNWVokflegjt7JKKLmL/tz6wJQHjKWgmRMZK5uAnt/Q==
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr4926753wro.250.1591284880431;
        Thu, 04 Jun 2020 08:34:40 -0700 (PDT)
Received: from [192.168.8.102] ([194.230.155.251])
        by smtp.gmail.com with ESMTPSA id q1sm7431317wmc.12.2020.06.04.08.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 08:34:39 -0700 (PDT)
Subject: Re: [PATCH v3 2/7] documentation for stats_fs
To:     Randy Dunlap <rdunlap@infradead.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526110318.69006-3-eesposit@redhat.com>
 <c9ddaed1-0efc-650b-6a51-ad5fc431af69@infradead.org>
From:   Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>
Message-ID: <dcaab39e-6cd3-c6cf-1515-7067a8b0ed9f@gmail.com>
Date:   Thu, 4 Jun 2020 17:34:37 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <c9ddaed1-0efc-650b-6a51-ad5fc431af69@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>> +
>> +The STATS_FS_HIDDEN attribute won't affect the aggregation, it will only
>> +block the creation of the files.
> 
> Why does HIDDEN block the creation of files?  instead of their visibility?

The file itself is used to allow the user to view the content of a 
value. In order to make it hidden, the framework just doesn't create the 
file.
The structure is still present and considered in statsfs, however.

Hidden in this case means not visible at all thus not created, not the 
hidden file concept of dotted files (".filename")

> 
>> +
>> +Add values to parent and child (also here order doesn't matter)::
>> +
>> +        struct kvm *base_ptr = kmalloc(..., sizeof(struct kvm));
>> +        ...
>> +        stats_fs_source_add_values(child_source, kvm_stats, base_ptr, 0);
>> +        stats_fs_source_add_values(parent_source, kvm_stats, NULL, STATS_FS_HIDDEN);
>> +
>> +``child_source`` will be a simple value, since it has a non-NULL base
>> +pointer, while ``parent_source`` will be an aggregate. During the adding
>> +phase, also values can optionally be marked as hidden, so that the folder
>> +and other values can be still shown.
>> +
>> +Of course the same ``struct stats_fs_value`` array can be also passed with a
>> +different base pointer, to represent the same value but in another instance
>> +of the kvm struct.
>> +
>> +Search:
>> +
>> +Fetch a value from the child source, returning the value
>> +pointed by ``(uint64_t *) base_ptr + kvm_stats[0].offset``::
>> +
>> +        uint64_t ret_child, ret_parent;
>> +
>> +        stats_fs_source_get_value(child_source, &kvm_stats[0], &ret_child);
>> +
>> +Fetch an aggregate value, searching all subsources of ``parent_source`` for
>> +the specified ``struct stats_fs_value``::
>> +
>> +        stats_fs_source_get_value(parent_source, &kvm_stats[0], &ret_parent);
>> +
>> +        assert(ret_child == ret_parent); // check expected result
>> +
>> +To make it more interesting, add another child::
>> +
>> +        struct stats_fs_source child_source2 = stats_fs_source_create(0, "child2");
>> +
>> +        stats_fs_source_add_subordinate(parent_source, child_source2);
>> +        // now  the structure is parent -> child1
>> +        //                              -> child2
> 
> Is that the same as                 parent -> child1 -> child2
> ?  It could almost be read as
>                                      parent -> child1
>                                      parent -> child2

No the example in the documentation shows the relationship
parent -> child1 and
parent -> child2.
It's not the same as
parent -> child1 -> child2.
In order to do the latter, one would need to do:

stats_fs_source_add_subordinate(parent_source, child_source1);
stats_fs_source_add_subordinate(child_source1, child_source2);

Hope that this clarifies it.

> 
> Whichever it is, can you make it more explicit, please?
> 
> 
>> +
>> +        struct kvm *other_base_ptr = kmalloc(..., sizeof(struct kvm));
>> +        ...
>> +        stats_fs_source_add_values(child_source2, kvm_stats, other_base_ptr, 0);
>> +
>> +Note that other_base_ptr points to another instance of kvm, so the struct
>> +stats_fs_value is the same but the address at which they point is not.
>> +
>> +Now get the aggregate value::
>> +
>> +        uint64_t ret_child, ret_child2, ret_parent;
>> +
>> +        stats_fs_source_get_value(child_source, &kvm_stats[0], &ret_child);
>> +        stats_fs_source_get_value(parent_source, &kvm_stats[0], &ret_parent);
>> +        stats_fs_source_get_value(child_source2, &kvm_stats[0], &ret_child2);
>> +
>> +        assert((ret_child + ret_child2) == ret_parent);
>> +
>> +Cleanup::
>> +
>> +        stats_fs_source_remove_subordinate(parent_source, child_source);
>> +        stats_fs_source_revoke(child_source);
>> +        stats_fs_source_put(child_source);
>> +
>> +        stats_fs_source_remove_subordinate(parent_source, child_source2);
>> +        stats_fs_source_revoke(child_source2);
>> +        stats_fs_source_put(child_source2);
>> +
>> +        stats_fs_source_put(parent_source);
>> +        kfree(other_base_ptr);
>> +        kfree(base_ptr);
>> +
>> +Calling stats_fs_source_revoke is very important, because it will ensure
> 
>             stats_fs_source_revoke()
> 
>> +that stats_fs will not access the data that were passed to
>> +stats_fs_source_add_value for this source.
>> +
>> +Because open files increase the reference count for a stats_fs_source, the
>> +source can end up living longer than the data that provides the values for
>> +the source.  Calling stats_fs_source_revoke just before the backing data
> 
>                          stats_fs_source_revoke()
> 
>> +is freed avoids accesses to freed data structures. The sources will return
>> +0.
>> +
>> +This is not needed for the parent_source, since it just contains
>> +aggregates that would be 0 anyways if no matching child value exist.
>> +
>> +API Documentation
>> +=================
>> +
>> +.. kernel-doc:: include/linux/stats_fs.h
>> +   :export: fs/stats_fs/*.c
>> \ No newline at end of file
> 
> Please fix that. ^^^^^
> 
> 
> Thanks for the documentation.
> 

Thank you for the feedback,
Emanuele
