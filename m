Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F03779A8B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfG2VC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:02:27 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37251 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728872AbfG2VC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:02:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id i70so18113783pgd.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ZNP1dL2Gsc2Pas+j9M/nuRQ/aXtV23x5/UcYOzbE5W4=;
        b=YlMUZ1neAloxg3y6lSr34XugQj5XeoAEyhxlv8SXJTPz/kveEnNqWZL3t7v7Vb8KkY
         tjdCDfPj8g6tEH/UiURvrbZd3cujgI+y/ch+nt/YxSs2P79uUFN3Ry47xzB/vXODHI85
         HET/lTgcSDrtfm91t22RMbGJ94yFWOpz2z9gadaqpL46VGy58Ufp1DKCV2/XI6QmuanG
         rqI+Fxed4sjYU+E+ZMVrcdXfIIyvkN3t2PoatSIOf+qhKVLO8n/BP4GJ2VPIvBzQnKwe
         3FEVbt+7fmHDP3n3tyknBJLSiq2P1o3gMfqPftejTC+kM90Ve089VMqzm/99/xuhEyC4
         g3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ZNP1dL2Gsc2Pas+j9M/nuRQ/aXtV23x5/UcYOzbE5W4=;
        b=Qn7F+BJVuCouL5TYthDXQvqoyN1uOM74eLvtueK6HH0V50Zbz8JlekPXP+nOH6Bl1I
         Xxj669bxhnwjanoY1lYf+wBCJR/3Z/h7rE4lJ60rk7J7urm2Tqb3wVHnoAe9oC8Dszeo
         tX8fuDoEX2edAjybqs/Df2VXi3+LdOegxM8GdA9X8Fc+P/dtnv3g/1L1nPaPo3JNUX0M
         nhlGcqFneLNOe4ucK24fwV9w1JuyK0m1jt5ojJfNqAhrZmtpvrdAL/E+Ljp3lJ9RkzPR
         GCTnlbPl/AocRKsbPEEY2dW0/9SLXdoUO72R74Dm3ZJY9woLy4X8FU0vDGR+dVlbNZ0n
         gAWg==
X-Gm-Message-State: APjAAAU+jf0gz5UdHQY4KjxW4LhgzG/QFSQo7HIBrFZyQjB9+UrGBzX8
        /SlYJIGxnQrasWXkT/KCBKA=
X-Google-Smtp-Source: APXvYqw+b/L90tvQ3Pdl4YXzTsDmiTIAzJxrO0EkdSEQVn/bqqRbvxUOxJdVc6QrHdIjWnNFEZaLOQ==
X-Received: by 2002:a63:e213:: with SMTP id q19mr104532998pgh.180.1564434146581;
        Mon, 29 Jul 2019 14:02:26 -0700 (PDT)
Received: from [172.20.52.209] ([2620:10d:c090:200::2:3dee])
        by smtp.gmail.com with ESMTPSA id 97sm57857599pjz.12.2019.07.29.14.02.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 14:02:26 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset accessors
Date:   Mon, 29 Jul 2019 14:02:21 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
In-Reply-To: <20190729135043.0d9a9dcb@cakuba.netronome.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
 <20190729171941.250569-2-jonathan.lemon@gmail.com>
 <20190729135043.0d9a9dcb@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29 Jul 2019, at 13:50, Jakub Kicinski wrote:

> On Mon, 29 Jul 2019 10:19:39 -0700, Jonathan Lemon wrote:
>> Add skb_frag_off(), skb_frag_off_add(), skb_frag_off_set(),
>> and skb_frag_off_set_from() accessors for page_offset.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>  include/linux/skbuff.h | 61 
>> ++++++++++++++++++++++++++++++++++++++----
>>  1 file changed, 56 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 718742b1c505..7d94a78067ee 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -331,7 +331,7 @@ static inline void skb_frag_size_set(skb_frag_t 
>> *frag, unsigned int size)
>>  }
>>
>>  /**
>> - * skb_frag_size_add - Incrementes the size of a skb fragment by 
>> %delta
>> + * skb_frag_size_add - Increments the size of a skb fragment by 
>> %delta
>>   * @frag: skb fragment
>>   * @delta: value to add
>>   */
>> @@ -2857,6 +2857,46 @@ static inline void 
>> skb_propagate_pfmemalloc(struct page *page,
>>  		skb->pfmemalloc = true;
>>  }
>>
>> +/**
>> + * skb_frag_off - Returns the offset of a skb fragment
>> + * @frag: the paged fragment
>> + */
>> +static inline unsigned int skb_frag_off(const skb_frag_t *frag)
>> +{
>> +	return frag->page_offset;
>> +}
>> +
>> +/**
>> + * skb_frag_off_add - Increments the offset of a skb fragment by 
>> %delta
>
> I realize you're following the existing code, but should we perhaps 
> use
> the latest kdoc syntax? '()' after function name, and args should have
> '@' prefix, '%' would be for constants.

That would be a task for a different cleanup.  Not that I disagree with 
you,
but there's also nothing worse than mixing styles in the same file.



>> + * @frag: skb fragment
>> + * @delta: value to add
>> + */
>> +static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
>> +{
>> +	frag->page_offset += delta;
>> +}
>> +
>> +/**
>> + * skb_frag_off_set - Sets the offset of a skb fragment
>> + * @frag: skb fragment
>> + * @offset: offset of fragment
>> + */
>> +static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int 
>> offset)
>> +{
>> +	frag->page_offset = offset;
>> +}
>> +
>> +/**
>> + * skb_frag_off_set_from - Sets the offset of a skb fragment from 
>> another fragment
>> + * @fragto: skb fragment where offset is set
>> + * @fragfrom: skb fragment offset is copied from
>> + */
>> +static inline void skb_frag_off_set_from(skb_frag_t *fragto,
>> +					 const skb_frag_t *fragfrom)
>
> skb_frag_off_copy() ?

That was my initial inclination, but due to the often overloaded
connotations of the word "copy", opted to use the same "set" verbiage
that existed in the other functions.


>> +{
>> +	fragto->page_offset = fragfrom->page_offset;
>> +}
>> +
>>  /**
>>   * skb_frag_page - retrieve the page referred to by a paged fragment
>>   * @frag: the paged fragment
>> @@ -2923,7 +2963,7 @@ static inline void skb_frag_unref(struct 
>> sk_buff *skb, int f)
>>   */
>>  static inline void *skb_frag_address(const skb_frag_t *frag)
>>  {
>> -	return page_address(skb_frag_page(frag)) + frag->page_offset;
>> +	return page_address(skb_frag_page(frag)) + skb_frag_off(frag);
>>  }
>>
>>  /**
>> @@ -2939,7 +2979,18 @@ static inline void 
>> *skb_frag_address_safe(const skb_frag_t *frag)
>>  	if (unlikely(!ptr))
>>  		return NULL;
>>
>> -	return ptr + frag->page_offset;
>> +	return ptr + skb_frag_off(frag);
>> +}
>> +
>> +/**
>> + * skb_frag_page_set_from - sets the page in a fragment from another 
>> fragment
>
> skb_frag_page_copy() ?

Same reasoning as above.



>> + * @fragto: skb fragment where page is set
>> + * @fragfrom: skb fragment page is copied from
>> + */
>> +static inline void skb_frag_page_set_from(skb_frag_t *fragto,
>> +					  const skb_frag_t *fragfrom)
>> +{
>> +	fragto->bv_page = fragfrom->bv_page;
>>  }
>>
>>  /**
