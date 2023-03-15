Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13706BAE79
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCOLGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCOLF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:05:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACD080927;
        Wed, 15 Mar 2023 04:05:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 91D571FD70;
        Wed, 15 Mar 2023 11:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678878356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byKaSG6OJ59VBwcTUhTpiXq5zlFsljvYFPU9Y2HdwDQ=;
        b=jYOBq5HuHp7Vn6xEt7/uP53ht3G85ZjFx5k7H4PVchE7eI8P7UDkW5miVps4PDJG0ThKHI
        ugEKyZ2/zA5BvmR9lpYlR89AHysqP0/7KudJYXjf4NGcwhkQTJa7kLLeU4FhVV5285n0uk
        kY1N9DsZoEXYFa0UNT158hhHQUJe/oE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678878356;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=byKaSG6OJ59VBwcTUhTpiXq5zlFsljvYFPU9Y2HdwDQ=;
        b=FZT8gQvYv9slINxxTxXBKSTnDHXDGB0JdcRCp9THbNUcqdt/nwSuEkFh9fuUJH4P7lHSES
        zLbml6AjoVOyTsAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CABB13A00;
        Wed, 15 Mar 2023 11:05:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LiNjEZSmEWTzXAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 15 Mar 2023 11:05:56 +0000
Message-ID: <bfacefe6-5852-3101-a016-3ee288a4e447@suse.cz>
Date:   Wed, 15 Mar 2023 12:05:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/7] mm, pagemap: remove SLOB and SLQB from comments and
 documentation
Content-Language: en-US
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Lorenzo Stoakes <lstoakes@gmail.com>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <20230310103210.22372-5-vbabka@suse.cz> <ZBAuBj0hgLK7Iqgy@localhost>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <ZBAuBj0hgLK7Iqgy@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 09:19, Hyeonggon Yoo wrote:
> On Fri, Mar 10, 2023 at 11:32:06AM +0100, Vlastimil Babka wrote:
>> SLOB has been removed and SLQB never merged, so remove their mentions
>> from comments and documentation of pagemap.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  Documentation/admin-guide/mm/pagemap.rst | 6 +++---
>>  fs/proc/page.c                           | 5 ++---
>>  2 files changed, 5 insertions(+), 6 deletions(-)
>> 
>> diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
>> index b5f970dc91e7..bb4aa897a773 100644
>> --- a/Documentation/admin-guide/mm/pagemap.rst
>> +++ b/Documentation/admin-guide/mm/pagemap.rst
>> @@ -91,9 +91,9 @@ Short descriptions to the page flags
>>     The page is being locked for exclusive access, e.g. by undergoing read/write
>>     IO.
>>  7 - SLAB
>> -   The page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator.
>> -   When compound page is used, SLUB/SLQB will only set this flag on the head
>> -   page; SLOB will not flag it at all.
>> +   The page is managed by the SLAB/SLUB kernel memory allocator.
>> +   When compound page is used, either will only set this flag on the head
>> +   page..
>>  10 - BUDDY
>>      A free memory block managed by the buddy system allocator.
>>      The buddy system organizes free memory in blocks of various orders.
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index 6249c347809a..1356aeffd8dc 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -125,7 +125,7 @@ u64 stable_page_flags(struct page *page)
>>  	/*
>>  	 * pseudo flags for the well known (anonymous) memory mapped pages
>>  	 *
>> -	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
>> +	 * Note that page->_mapcount is overloaded in SLAB/SLUB, so the
> 
> SLUB does not overload _mapcount.

True, I overlooked that, thanks.

>>  	 * simple test in page_mapped() is not enough.
>>  	 */
>>  	if (!PageSlab(page) && page_mapped(page))
>> @@ -166,8 +166,7 @@ u64 stable_page_flags(struct page *page)
>>  
>>  	/*
>>  	 * Caveats on high order pages: page->_refcount will only be set
>> -	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
>> -	 * SLOB won't set PG_slab at all on compound pages.
>> +	 * -1 on the head page; SLAB/SLUB do the same for PG_slab;
> 
> I think this comment could be just saying that PG_buddy is only set on
> head page, not saying
> 
> _refcount is set to -1 on head page (is it even correct?)

It's not, that scheme is outdated. So I'll have it mention PG_buddy as you
suggest, but PG_slab also needs special care as it's not set on tail pages.
But I noticed the compound_head() is unnecessary as that's covered by
PageSlab() which is defined as PF_NO_TAIL. So the sum of modifications to
this patch:

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index bb4aa897a773..c8f380271cad 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -93,7 +93,7 @@ Short descriptions to the page flags
 7 - SLAB
    The page is managed by the SLAB/SLUB kernel memory allocator.
    When compound page is used, either will only set this flag on the head
-   page..
+   page.
 10 - BUDDY
     A free memory block managed by the buddy system allocator.
     The buddy system organizes free memory in blocks of various orders.
diff --git a/fs/proc/page.c b/fs/proc/page.c
index 1356aeffd8dc..195b077c0fac 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -125,7 +125,7 @@ u64 stable_page_flags(struct page *page)
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 *
-	 * Note that page->_mapcount is overloaded in SLAB/SLUB, so the
+	 * Note that page->_mapcount is overloaded in SLAB, so the
 	 * simple test in page_mapped() is not enough.
 	 */
 	if (!PageSlab(page) && page_mapped(page))
@@ -165,8 +165,8 @@ u64 stable_page_flags(struct page *page)
 
 
 	/*
-	 * Caveats on high order pages: page->_refcount will only be set
-	 * -1 on the head page; SLAB/SLUB do the same for PG_slab;
+	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
+	 * on the head page.
 	 */
 	if (PageBuddy(page))
 		u |= 1 << KPF_BUDDY;
@@ -184,7 +184,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
-	if (PageTail(page) && PageSlab(compound_head(page)))
+	if (PageTail(page) && PageSlab(page))
 		u |= 1 << KPF_SLAB;
 
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);



