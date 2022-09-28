Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BB35EDF3C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiI1Owc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiI1OwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:52:11 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E7FB2CC5;
        Wed, 28 Sep 2022 07:52:02 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-13175b79807so7504835fac.9;
        Wed, 28 Sep 2022 07:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=TIZXzEKYi8YkccEetyBjMgWXZYUaHtf6GUbWjD4kbBI=;
        b=JVValpnyOwlAuIhkmcDbq0qeAKvw0R/3cXOXm8z80Vy6Hfs3QqwFaRA69kqQkDhuuk
         zr2D0zU+f1Y6wOt7NCBIT2K8b+4jb/Dle69t7b3VbY7B1XDtxZAUzbseMIuhuhtbfwWK
         jvwFSYfbpBmgLDClsYJ5kKciNQlWxjkcaIiGWhGhz1bBN44LoLl54AKjna6FWzuXxOui
         10HucYYI+duWD/Bbuf/JZ3B+kyVGQf84OS/kgKrNjutdGZxR17MyT+DAX9YzpAq5LY1Y
         wsTf1DqBh2LSsYwDVgB+UcfUCkaBYwLiXHETDqBEKgcMS9x/nh3XNoAy+oWdulk9A1AI
         jBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TIZXzEKYi8YkccEetyBjMgWXZYUaHtf6GUbWjD4kbBI=;
        b=n92Unyp5h8oksTNWXnvhLLrPaSu5FjDlZbU2bxkS3n60PhRWIdXxK5aPBDqXHpLSdN
         jJepsTNvXIL0+c4qwOv2uJkoAEbglEfOiH8ejOsYFoVEYEqEEiFTaHQY+gFic1tAftDO
         VTf4kMCjP9L0IoZxW1fdXjX1+RaW8Q5vqi1nG9KmvXlyEZyiuWG0OI06Vs+1jWcJwWUH
         E/7Gr1gJdyOIlZMWmXpvBdFLtAhnHJFBy8bOZpMp4kdKTY+m6pvO32Wv2R+ce+BRAYdy
         M9FtuZplnPcMTNWl5zqABe0Gf1UMd0nVjPHI4e2xrt9Q3oF/uqeZQtd4qLsFlSzWTalm
         Dqbw==
X-Gm-Message-State: ACrzQf2SEItynjVlUuzdj3TFo5HetPRiHXI4xL8FEyBeowWv7b9og3fe
        HSK5l9z4ikU6Y++UXWHtZa8=
X-Google-Smtp-Source: AMsMyM4II/936alaoenNFePZ24iaLn0fbfgLrQ7d70SFig8ZY4YqnEZqQTgZycuf3hiIqQIclDYJWg==
X-Received: by 2002:a05:6870:d24e:b0:127:ba61:5343 with SMTP id h14-20020a056870d24e00b00127ba615343mr5434001oac.81.1664376721539;
        Wed, 28 Sep 2022 07:52:01 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id k9-20020a056830168900b0063695ad0cbesm2136923otr.66.2022.09.28.07.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:52:01 -0700 (PDT)
Date:   Wed, 28 Sep 2022 07:49:51 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/7] cpumask: fix checking valid cpu range
Message-ID: <YzRfD2aAID8DuHL1@yury-laptop>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
 <20220919210559.1509179-2-yury.norov@gmail.com>
 <xhsmhbkqz4rqr.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmhbkqz4rqr.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 01:18:20PM +0100, Valentin Schneider wrote:
> On 19/09/22 14:05, Yury Norov wrote:
> > The range of valid CPUs is [0, nr_cpu_ids). Some cpumask functions are
> > passed with a shifted CPU index, and for them, the valid range is
> > [-1, nr_cpu_ids-1). Currently for those functions, we check the index
> > against [-1, nr_cpu_ids), which is wrong.
> >
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > ---
> >  include/linux/cpumask.h | 19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index e4f9136a4a63..a1cd4eb1a3d6 100644
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -174,9 +174,8 @@ static inline unsigned int cpumask_last(const struct cpumask *srcp)
> >  static inline
> >  unsigned int cpumask_next(int n, const struct cpumask *srcp)
> >  {
> > -	/* -1 is a legal arg here. */
> > -	if (n != -1)
> > -		cpumask_check(n);
> > +	/* n is a prior cpu */
> > +	cpumask_check(n + 1);
> >       return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
> 
> I'm confused, this makes passing nr_cpu_ids-1 to cpumask_next*() trigger a
> warning. The documentation does states:
> 
> * @n: the cpu prior to the place to search (ie. return will be > @n)
> 
> So n is a valid CPU number (with -1 being the exception for scan
> initialization), this shouldn't exclude nr_cpu_ids-1.

For a regular cpumask function, like cpumask_any_but(), the valid range is
[0, nr_cpu_ids).

'Special' functions shift by 1 when call underlying find API:

  static inline
  unsigned int cpumask_next(int n, const struct cpumask *srcp)
  {
          /* n is a prior cpu */
          cpumask_check(n + 1);
          return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
  }

So, for them the valid range [0, nr_cpu_ids) must be shifted in other
direction: [-1, nr_cpu_ids-1). 

> IMO passing nr_cpu_ids-1 should be treated the same as passing the
> last set bit in a bitmap: no warning, and returns the bitmap
> size.

This is how cpumask_check() works for normal functions. For
cpumask_next() passing nr_cpu_ids-1 is the same as passing nr_cpu_ids
for cpumask_any_but(), and it should trigger warning in both cases.
(Or should not, but it's a different story.)

> calling code which seems like unnecessary boiler plate
> 
> For instance, I trigger the cpumask_check() warning there:
> 
> 3d2dcab932d0:block/blk-mq.c @l2047
>         if (--hctx->next_cpu_batch <= 0) {
> select_cpu:
>                 next_cpu = cpumask_next_and(next_cpu, hctx->cpumask, <-----
>                                 cpu_online_mask);
>                 if (next_cpu >= nr_cpu_ids)
>                         next_cpu = blk_mq_first_mapped_cpu(hctx);
>                 hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
>         }
> 
> next_cpu is a valid CPU number, shifting it doesn't seem to make sense, and
> we do want it to reach nr_cpu_ids-1.

next_cpu is a valid CPU number for all, but not for cpumask_next().
The warning is valid. If we are at the very last cpu, what for we look
for next?

The snippet above should be fixed like this:

          if (--hctx->next_cpu_batch <= 0) {
  select_cpu:
                  if (next_cpu == nr_cpu_ids - 1)
                          next_cpu = nr_cpu_ids;
                  else
                          next_cpu = cpumask_next_and(next_cpu,
                                                      hctx->cpumask,
                                                      cpu_online_mask);
                  if (next_cpu >= nr_cpu_ids)
                          next_cpu = blk_mq_first_mapped_cpu(hctx);
                  hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
          }

The original motivation for this special shifted semantics was to
avoid passing '+1' in cpumask_next() everywhere where it's used to
iterate over cpumask. This is especially ugly because it brings negative
semantics in such a simple thing like an index, and makes people confused.
It was a bad decision, but now it's so broadly used that we have to live
with it.

The strategy to mitigate this is to minimize using of that 'special'
functions. They all are cpumask_next()-like. In this series I reworked
for_each_cpu() to not use cpumask_next().

Often, cpumask_next() is a part of opencoded for_each_cpu(), and this
is relatively easy to fix. In case of blk_mq_hctx_next_cpu() that you
mentioned above, cpumask_next_and() usage looks unavoidable, and
there's nothing to do with that, except that being careful.

It didn't trigger the warning in my test setup, so I didn't fix it.
Feel free to submit a patch, if you observe the warning for yourself.

Maybe we should consider nr_cpu_ids as a special valid index for
cpumask_check(), a sign of the end of an array. This would help to
silence many warnings, like this one. For now I'm leaning towards that
it's more a hack than a meaningful change. 

Thanks,
Yury
