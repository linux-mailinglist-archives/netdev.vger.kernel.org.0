Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F601FBE34
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 20:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgFPSgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 14:36:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729853AbgFPSgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 14:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592332591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/6v2jfN6UIDhJeosnSs1R4UAP7mOiLuFVPEnJvGTnM=;
        b=VsbTXqwl7xxf+MUWbnJM4vCOVIS/iCxA1SAjzyA8FsjzrodShKHnZfMLXBOQL/GHNJH8vC
        OuxP6I6blTXluNjdUqYdGiIeMKVM7wFH4inGVQHpTaw8gw2uwB0FCvyIBJbPEBsvhu17TV
        Bbxsdyz8zlcvC51jFF/xVTwdyLhzHT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-AXrSOJCONRyyvrghDqFtvA-1; Tue, 16 Jun 2020 14:36:27 -0400
X-MC-Unique: AXrSOJCONRyyvrghDqFtvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2578680332A;
        Tue, 16 Jun 2020 18:36:22 +0000 (UTC)
Received: from llong.remote.csb (ovpn-114-156.rdu2.redhat.com [10.10.114.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B77519C71;
        Tue, 16 Jun 2020 18:36:16 +0000 (UTC)
Subject: Re: [PATCH v5 2/2] mm, treewide: Rename kzfree() to kfree_sensitive()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ecryptfs@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
References: <20200616154311.12314-1-longman@redhat.com>
 <20200616154311.12314-3-longman@redhat.com>
 <20200616110944.c13f221e5c3f54e775190afe@linux-foundation.org>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <65002c1e-5e31-1f4e-283c-186e06e55ef0@redhat.com>
Date:   Tue, 16 Jun 2020 14:36:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200616110944.c13f221e5c3f54e775190afe@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 2:09 PM, Andrew Morton wrote:
> On Tue, 16 Jun 2020 11:43:11 -0400 Waiman Long <longman@redhat.com> wrote:
>
>> As said by Linus:
>>
>>    A symmetric naming is only helpful if it implies symmetries in use.
>>    Otherwise it's actively misleading.
>>
>>    In "kzalloc()", the z is meaningful and an important part of what the
>>    caller wants.
>>
>>    In "kzfree()", the z is actively detrimental, because maybe in the
>>    future we really _might_ want to use that "memfill(0xdeadbeef)" or
>>    something. The "zero" part of the interface isn't even _relevant_.
>>
>> The main reason that kzfree() exists is to clear sensitive information
>> that should not be leaked to other future users of the same memory
>> objects.
>>
>> Rename kzfree() to kfree_sensitive() to follow the example of the
>> recently added kvfree_sensitive() and make the intention of the API
>> more explicit. In addition, memzero_explicit() is used to clear the
>> memory to make sure that it won't get optimized away by the compiler.
>>
>> The renaming is done by using the command sequence:
>>
>>    git grep -w --name-only kzfree |\
>>    xargs sed -i 's/\bkzfree\b/kfree_sensitive/'
>>
>> followed by some editing of the kfree_sensitive() kerneldoc and adding
>> a kzfree backward compatibility macro in slab.h.
>>
>> ...
>>
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -186,10 +186,12 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *, struct mem_cgroup *);
>>    */
>>   void * __must_check krealloc(const void *, size_t, gfp_t);
>>   void kfree(const void *);
>> -void kzfree(const void *);
>> +void kfree_sensitive(const void *);
>>   size_t __ksize(const void *);
>>   size_t ksize(const void *);
>>   
>> +#define kzfree(x)	kfree_sensitive(x)	/* For backward compatibility */
>> +
> What was the thinking here?  Is this really necessary?
>
> I suppose we could keep this around for a while to ease migration.  But
> not for too long, please.
>
It should be there just for 1 release cycle. I have broken out the btrfs 
patch to the btrfs list and I didn't make the kzfree to kfree_sensitive 
conversion there as that patch was in front in my patch list. So 
depending on which one lands first, there can be a window where the 
compilation may fail without this workaround. I am going to send out 
another patch in the next release cycle to remove it.

Cheers,
Longman

