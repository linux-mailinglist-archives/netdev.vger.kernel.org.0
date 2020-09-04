Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BD725D0CF
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 07:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIDFII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 01:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgIDFIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 01:08:06 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FA9C061244;
        Thu,  3 Sep 2020 22:08:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o68so3972387pfg.2;
        Thu, 03 Sep 2020 22:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ecJ6br0bOEqdX8tcGVb8URqHSI/ob4YFt4Jw7wg6Ia0=;
        b=b8nlPOOlOHQn+lEuwRWvHwAQqNuifcifVvLhsW8dvfjkY2mdTgiNGgEZxWaJmpzntt
         Hn5HT5oTuWCRlToi3q+vgzgSY5+yDEcx96qOfweqjZtU8k35kLoDOGUt0WyUgPQkeX/K
         jxcDECeyA4ppLcPAegF1f6k6xyvXc2oxUiUaUz6iGTU+qAH14iUfq8ih9LwBhAenkeTC
         654edaVTafviomkG9HcSFRCR1Jvv85Rl3uLJNKrRY9efCwuKgTiWSPWqmQwYFrtxW9vg
         smwup7jheDRfTdfWyEHUenuexoJk5EO/aHfVZM3nRrUD2Hu5EzTVHCQtXJCsnn7M38P/
         wxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ecJ6br0bOEqdX8tcGVb8URqHSI/ob4YFt4Jw7wg6Ia0=;
        b=fjTIkzaltBvB1IKehc4LTibjnpYzKVHDMlQtG56/dOPLxdUI2dkruNvXBhRMychrUL
         Outgo6/TOB/DrrdwV9DQTGDJ3J3ZkBF//BNz/hMkaqEz/Q3D/fooxAMpZ+DSkMNj08MB
         qb+zhvg+6RPj7qsgdrGdV1V8MAYutpczSFJDrwRlxVgHo0fcBGDM6avJfPRNhRAvyKZL
         KeSOrcH/c7oASKHHZGO813mcHCJurfoGYNwHV9kKFzP5TnFkzTm8DWfnFxz3EJEZ9oDZ
         RD7O170Bqq73cNON9vuu/oIjQaAJwWX/9BsZn9ZVSwAqoZwJpgEV8K2V8RbJRdrVCYNG
         5lnA==
X-Gm-Message-State: AOAM532StL1QltuiR5ban617H1s5G84oOGlWI+Ij+e1QTmut4O7DaTEd
        4U5Lt7ocYm7dIH4byENGVnc=
X-Google-Smtp-Source: ABdhPJzeF5lk/iuosObv9Ll4NXB/zgMfsHAkWm96fxL4NlgqZBhQmtxFHr4hu82v5C4PM6zQQ+qTzw==
X-Received: by 2002:a63:43c7:: with SMTP id q190mr5619640pga.6.1599196085186;
        Thu, 03 Sep 2020 22:08:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d17sm2406504pfq.157.2020.09.03.22.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 22:08:04 -0700 (PDT)
Date:   Thu, 03 Sep 2020 22:07:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Message-ID: <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
 <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
 <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com>
 <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com>
 <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com>
 <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Sep 3, 2020 at 1:40 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Wed, 2020-09-02 at 22:01 -0700, Cong Wang wrote:
> > > Can you test the attached one-line fix? I think we are overthinking,
> > > probably all
> > > we need here is a busy wait.
> >
> > I think that will solve, but I also think that will kill NOLOCK
> > performances due to really increased contention.
> 
> Yeah, we somehow end up with more locks (seqlock, skb array lock)
> for lockless qdisc. What an irony... ;)

I went back to the original nolock implementation code to try and figure
out how this was working in the first place.

After initial patch series we have this in __dev_xmit_skb()

	if (q->flags & TCQ_F_NOLOCK) {
		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
			__qdisc_drop(skb, &to_free);
			rc = NET_XMIT_DROP;
		} else {
			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
			__qdisc_run(q);
		}

		if (unlikely(to_free))
			kfree_skb_list(to_free);
		return rc;
	}

One important piece here is we used __qdisc_run(q) instead of
what we have there now qdisc_run(q). Here is the latest code,


	if (q->flags & TCQ_F_NOLOCK) { 
		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
		qdisc_run(q);
		...

__qdisc_run is going to always go into a qdisc_restart loop and
dequeue packets. There is no check here to see if another CPU
is running or not. Compare that to qdisc_run()

	static inline void qdisc_run(struct Qdisc *q)
	{
		if (qdisc_run_begin(q)) {
			__qdisc_run(q);
			qdisc_run_end(q);
		}
	}

Here we have all the racing around qdisc_is_running() that seems
unsolvable.

Seems we flipped __qdisc_run to qdisc_run here 32f7b44d0f566
("sched: manipulate __QDISC_STATE_RUNNING in qdisc_run_* helpers"). 
Its not clear to me from thatpatch though why it was even done
there?

Maybe this would unlock us,

diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..9b09429103f1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3749,7 +3749,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 	if (q->flags & TCQ_F_NOLOCK) {
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-		qdisc_run(q);
+		__qdisc_run(q);
 
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);


Per other thread we also need the state deactivated check added
back.

> 
> >
> > At this point I fear we could consider reverting the NOLOCK stuff.
> > I personally would hate doing so, but it looks like NOLOCK benefits are
> > outweighed by its issues.
> 
> I agree, NOLOCK brings more pains than gains. There are many race
> conditions hidden in generic qdisc layer, another one is enqueue vs.
> reset which is being discussed in another thread.

Sure. Seems they crept in over time. I had some plans to write a
lockless HTB implementation. But with fq+EDT with BPF it seems that
it is no longer needed, we have a more generic/better solution.  So
I dropped it. Also most folks should really be using fq, fq_codel,
etc. by default anyways. Using pfifo_fast alone is not ideal IMO.

Thanks,
John
