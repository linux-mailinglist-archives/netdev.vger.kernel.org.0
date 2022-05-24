Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050C3532163
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiEXCzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiEXCzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:55:43 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9192B9154F
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:55:41 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a13so4190071plh.6
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J/50AJ+NI1zkbT6APU/2qPIMTTrEA99XU7T3yxnY62c=;
        b=aOVkZJKkSAgfD5oNFcEnzXGX1rmfvMHJGmJ7+xiSeEQJFUfZq7FmHKnaeNnnOj+TM/
         LV5hzgkPywS1pKlyXQSeLS6Wmbg5C61WJfY6R5LdzIC2QIEfp7mjOjuR7pCIha7SBCyv
         CoMak2TLLzAGSYYA9xkDjQGj8okKZoLqlf8apxgtJztDhtGzSpEQiM5yzhapuJKBxzT6
         Z58+ukLQztQF8qTUVGKTMv8ZkStHaWIJQI+KpA2ewcHv87V33Ulv8hww5j2Icy+sI+P3
         2qgCzNrbWoEpCegFVe96fwbgb6w63m4R8RkY7Qfj+LfLZ1w7P0Io7U940jTTWOQxSpPi
         C/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J/50AJ+NI1zkbT6APU/2qPIMTTrEA99XU7T3yxnY62c=;
        b=NWiN8c6wUfFhATiQj9bZBfj0T8EVRJpNyd9AVzsBFO/Jhe3OIMqnTxKRsYfzMJ0kSJ
         1LErT4eqANr6R5HYI2KUROKmKAuRdJ6u2RW3C9vxrxD4MU6wbF6bMwDgFDuhTGbnjGQV
         kgmA10lHkwTgicNppH6+xuoqo2CGE3u0g//GgS8SfuFGtQUjDWqOGx8yqGRoxJOjhmXU
         CgtBZ79NHgpBbj45OGSrlJv2Ha45poir4lj2yPxWCWXbRmVRfBbT8yFwlM/N+4QTjPN1
         M6t9WALmj9A61dKdo9Q4gT1utA284FM/5cRnseX10Qv0iEsV7crhExnJ77hltetdUkEC
         trtg==
X-Gm-Message-State: AOAM533gNSINmySc5p+ZnDxv3m5RNPL3UuEroGFkDuhZPTsd5OdqfJNz
        hOF/+lP+B+eTRis1BU4HsFk=
X-Google-Smtp-Source: ABdhPJxzBn3yzrJzGFBu3AVpHUwCxLPt+vmYIU+yIrCn8WND9O0O4j1uUDxUDnrGDrHD+Uu7hv1BGA==
X-Received: by 2002:a17:902:f54b:b0:162:44c4:6190 with SMTP id h11-20020a170902f54b00b0016244c46190mr549569plf.119.1653360940980;
        Mon, 23 May 2022 19:55:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c23-20020a170902c2d700b00162037fbb68sm5771387pla.215.2022.05.23.19.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 19:55:40 -0700 (PDT)
Message-ID: <b35b766c-a25a-fcf7-d329-31948e219f5d@gmail.com>
Date:   Mon, 23 May 2022 19:55:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: packet stuck in qdisc : patch proposal
Content-Language: en-US
To:     Vincent Ray <vray@kalrayinc.com>,
        linyunsheng <linyunsheng@huawei.com>
Cc:     davem <davem@davemloft.net>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Guoju Fang <gjfang@linux.alibaba.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>,
        Eric Dumazet <edumazet@google.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/23/22 06:54, Vincent Ray wrote:
> Hi Yunsheng, all,
>
> I finally spotted the bug that caused (nvme-)tcp packets to remain stuck in the qdisc once in a while.
> It's in qdisc_run_begin within sch_generic.h :
>
> smp_mb__before_atomic();
>   
> // [comments]
>
> if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> 	return false;
>
> should be
>
> smp_mb();
>
> // [comments]
>
> if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> 	return false;
>
> I have written a more detailed explanation in the attached patch, including a race example, but in short that's because test_bit() is not an atomic operation.
> Therefore it does not give you any ordering guarantee on any architecture.
> And neither does spin_trylock() called at the beginning of qdisc_run_begin() when it does not grab the lock...
> So test_bit() may be reordered whith a preceding enqueue(), leading to a possible race in the dialog with pfifo_fast_dequeue().
> We may then end up with a skbuff pushed "silently" to the qdisc (MISSED cleared, nobody aware that there is something in the backlog).
> Then the cores pushing new skbuffs to the qdisc may all bypass it for an arbitrary amount of time, leaving the enqueued skbuff stuck in the backlog.
>
> I believe the reason for which you could not reproduce the issue on ARM64 is that, on that architecture, smp_mb__before_atomic() will translate to a memory barrier.
> It does not on x86 (turned into a NOP) because you're supposed to use this function just before an atomic operation, and atomic operations themselves provide full ordering effects on x86.
>
> I think the code has been flawed for some time but the introduction of a (true) bypass policy in 5.14 made it more visible, because without this, the "victim" skbuff does not stay very long in the backlog : it is bound to pe popped by the next core executing __qdic_run().
>
> In my setup, with our use case (16 (virtual) cpus in a VM shooting 4KB buffers with fio through a -i4 nvme-tcp connection to a target), I did not notice any performance degradation using smp_mb() in place of smp_mb__before_atomic(), but of course that does not mean it cannot happen in other configs.
>
> I think Guoju's patch is also correct and necessary so that both patches, his and mine, should be applied "asap" to the kernel.
> A difference between Guoju's race and "mine" is that, in his case, the MISSED bit will be set : though no one will take care of the skbuff immediately, the next cpu pushing to the qdisc (if ever ...) will notice and dequeue it (so Guoju's race probably happens in my use case too but is not noticeable).
>
> Finally, given the necessity of these two new full barriers in the code, I wonder if the whole lockless (+ bypass) thing should be reconsidered.
> At least, I think general performance tests should be run to check that lockless qdics still outperform locked qdiscs, in both bypassable and not-bypassable modes.
>      
> More generally, I found this piece of code quite tricky and error-prone, as evidenced by the numerous fixes it went through in the recent history.
> I believe most of this complexity comes from the lockless qdisc handling in itself, but of course the addition of the bypass support does not really help ;-)
> I'm a linux kernel beginner however, so I'll let more experienced programmers decide about that :-)
>
> I've made sure that, with this patch, no stuck packets happened any more on both v5.15 and v5.18-rc2 (whereas without the patch, numerous occurrences of stuck packets are visible).
> I'm quite confident it will apply to any concerned version, that is from 5.14 (or before) to mainline.
>
> Can you please tell me :
>
> 1) if you agree with this ?
>
> 2) how to proceed to push this patch (and Guoju's) for quick integration into the mainline ?
>
> NB : an alternative fix (which I've tested OK too) would be to simply remove the
>
> if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
> 	return false;
>
> code path, but I have no clue if this would be better or worse than the present patch in terms of performance.
>      
> Thank you, best regards,
>
> V


We keep adding code and comments, this is quite silly.

test_and_set_bit() is exactly what we need.


diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 
9bab396c1f3ba3d143de4d63f4142cff3c9b9f3e..9d1b448c0dfc3925967635f3390b884a4ef7c55a 
100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -187,35 +187,9 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
                 if (spin_trylock(&qdisc->seqlock))
                         return true;

-               /* Paired with smp_mb__after_atomic() to make sure
-                * STATE_MISSED checking is synchronized with clearing
-                * in pfifo_fast_dequeue().
-                */
-               smp_mb__before_atomic();
-
-               /* If the MISSED flag is set, it means other thread has
-                * set the MISSED flag before second spin_trylock(), so
-                * we can return false here to avoid multi cpus doing
-                * the set_bit() and second spin_trylock() concurrently.
-                */
-               if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
+               if (test_and_set_bit(__QDISC_STATE_MISSED, &qdisc->state))
                         return false;

-               /* Set the MISSED flag before the second spin_trylock(),
-                * if the second spin_trylock() return false, it means
-                * other cpu holding the lock will do dequeuing for us
-                * or it will see the MISSED flag set after releasing
-                * lock and reschedule the net_tx_action() to do the
-                * dequeuing.
-                */
-               set_bit(__QDISC_STATE_MISSED, &qdisc->state);
-
-               /* spin_trylock() only has load-acquire semantic, so use
-                * smp_mb__after_atomic() to ensure STATE_MISSED is set
-                * before doing the second spin_trylock().
-                */
-               smp_mb__after_atomic();
-
                 /* Retry again in case other CPU may not see the new flag
                  * after it releases the lock at the end of 
qdisc_run_end().
                  */

