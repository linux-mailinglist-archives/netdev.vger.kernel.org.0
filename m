Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8345F596A
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJER4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJER4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:56:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE18276768
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 10:56:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f140so11192073pfa.1
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 10:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=c5TvtegkYOrbEgcQjqz0taNxGCXz8814bAat1R61jG4=;
        b=Eyg1f1oxonLXXUIbmurppaA97xnV8i97svyNx9d4l36TDkGsSv0v1vk//c5wqL18dR
         WzqbEVNKDHKfdfJcfzwUQMUS7bab0g8PBVZlfz8KSc/qAQLt9/5Ea61Jq+fe57gcx0o0
         7GfhZLpkcT/bZQPd2WBIsmGlRSHLwxMtR3cr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=c5TvtegkYOrbEgcQjqz0taNxGCXz8814bAat1R61jG4=;
        b=yVVOhQ4MsnbDIK9KnLxNJEYq85dE5rUjixWAQXyhnLt1h+8y5nC+HyemCF/ewL8hjM
         ZCrmabZW+iLIxcFbweUODs7hFU2S3+jUzt3QHMcpcTYeaHYgNEnwcq3uPrbF+WAq9J1k
         ZF0/sKixUcOloV1jva6lUHwVANMTFy/cOPV/Azsu+UZPigX1jUhCw9Iir/v53ls3wnMI
         6G5/tU8Xd5Kq3N905CkBzLmvtrAHcR5S3GlqqrpsR4raYaaHWEZjkmeG/oMvxJv3hmf0
         mzCPKKN9N9nYuHeiuztOPE4aSPRHEzG3pjRZrZIC+vDnZ+UqQV6kdFDBnZVCkxC7RAtW
         Tvag==
X-Gm-Message-State: ACrzQf2vGFCBXrX2Esp6Ybpg6FPEvXxUJHR4cA0Zg0bf1NnNySf3zyBO
        Tfy0BjBUNRu3LTNkeHYxRm12VA==
X-Google-Smtp-Source: AMsMyM75zhmdcRzEOdMtwvhxCSk9hwHvWmO+hrQc+05dVEyZaDbRCfUEB7SjFdF6oZthJrNzUAV1hw==
X-Received: by 2002:a62:1b8f:0:b0:54b:8114:e762 with SMTP id b137-20020a621b8f000000b0054b8114e762mr877483pfb.7.1664992582278;
        Wed, 05 Oct 2022 10:56:22 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id ij28-20020a170902ab5c00b00178af82a000sm10732842plb.122.2022.10.05.10.56.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 10:56:22 -0700 (PDT)
Date:   Wed, 5 Oct 2022 10:56:19 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [next-queue 3/3] i40e: Add i40e_napi_poll tracepoint
Message-ID: <20221005175619.GB11626@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-4-git-send-email-jdamato@fastly.com>
 <Yz1cEtPLzbPkBCtV@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz1cEtPLzbPkBCtV@boxer>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:27:30PM +0200, Maciej Fijalkowski wrote:
> On Wed, Oct 05, 2022 at 01:31:43AM -0700, Joe Damato wrote:
> 
> Hi Joe,
> 
> > Add a tracepoint for i40e_napi_poll that allows users to get detailed
> > information about the amount of work done. This information can help users
> > better tune the correct NAPI parameters (like weight and budget), as well
> > as debug NIC settings like rx-usecs and tx-usecs, etc.
> > 
> > An example of the output from this tracepoint:
> > 
> > [...snip...]
> > 
> > 1029.268 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth1 q
> > i40e-eth1-TxRx-30 irq 172 irq_mask
> > 00000000,00000000,00000000,00000010,00000000,00000000 curr_cpu 68 budget
> > 64 bpr 64 work_done 0 tx_work_done 2 clean_complete 1 tx_clean_complete
> > 1)
> > 	i40e_napi_poll ([i40e])
> > 	i40e_napi_poll ([i40e])
> > 	__napi_poll ([kernel.kallsyms])
> > 	net_rx_action ([kernel.kallsyms])
> > 	__do_softirq ([kernel.kallsyms])
> > 	common_interrupt ([kernel.kallsyms])
> > 	asm_common_interrupt ([kernel.kallsyms])
> > 	intel_idle_irq ([kernel.kallsyms])
> > 	cpuidle_enter_state ([kernel.kallsyms])
> > 	cpuidle_enter ([kernel.kallsyms])
> > 	do_idle ([kernel.kallsyms])
> > 	cpu_startup_entry ([kernel.kallsyms])
> > 	[0x243fd8] ([kernel.kallsyms])
> > 	secondary_startup_64_no_verify ([kernel.kallsyms])
> 
> maybe you could also include how to configure this tracepoint for future
> readers?

Ah, for some reason I deleted that line from the commit message. Will
include it in the v2.

> > 
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_trace.h | 50 ++++++++++++++++++++++++++++
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c  |  3 ++
> >  2 files changed, 53 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
> > index b5b1229..779d046 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
> > @@ -55,6 +55,56 @@
> >   * being built from shared code.
> >   */
> >  
> > +#define NO_DEV "(i40e no_device)"
> > +
> > +TRACE_EVENT(i40e_napi_poll,
> > +
> > +	TP_PROTO(struct napi_struct *napi, struct i40e_q_vector *q, int budget,
> > +		 int budget_per_ring, int work_done, int tx_work_done, bool clean_complete,
> > +		 bool tx_clean_complete),
> > +
> > +	TP_ARGS(napi, q, budget, budget_per_ring, work_done, tx_work_done,
> > +		clean_complete, tx_clean_complete),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(int, budget)
> > +		__field(int, budget_per_ring)
> > +		__field(int, work_done)
> > +		__field(int, tx_work_done)
> > +		__field(int, clean_complete)
> > +		__field(int, tx_clean_complete)
> > +		__field(int, irq_num)
> > +		__field(int, curr_cpu)
> > +		__string(qname, q->name)
> > +		__string(dev_name, napi->dev ? napi->dev->name : NO_DEV)
> > +		__bitmask(irq_affinity,	nr_cpumask_bits)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->budget = budget;
> > +		__entry->budget_per_ring = budget_per_ring;
> > +		__entry->work_done = work_done;
> 
> What if rx clean routines failed to do allocation of new rx bufs? then
> this would be misinterpreted. maybe we should change the API to
> 
> static bool
> i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
> 		  unsigned int *processed_pkts);
> 
> so you would return failure and at the end do
> 	*processed_pkts = total_rx_packets;

I reworked i40e_clean_rx_irq and i40e_clean_rx_irq_zc to do what you've
described -- this is also how I ended up approaching counting TX cleaned.

> 
> then also i would change the naming of tracepoint entry. I'm not a native
> english speaker but having 'done' within the variable name suggests to me
> that it is rather a boolean. what about something like 'rx_cleaned_pkts'
> instead?

Sure, I've changed the trace prototype, struct, and print statement to use
"rx_cleaned" and "tx_cleaned" instead of "work_done" and "tx_work_done".

>
> Generally I think this is useful, personally I was in need of tracing the
> next_to_clean and next_to_use ring indexes a lot, but that is probably out
> of the scope in here.

Yea, I've used those for debugging other things, as well - they are quite
useful, but I agree... I think that's out of scope for this set :)

Thank you very much for all your detailed feedback. Hopefully the v2 will
be a bit closer.

> > +		__entry->tx_work_done = tx_work_done;
> > +		__entry->clean_complete = clean_complete;
> > +		__entry->tx_clean_complete = tx_clean_complete;
> > +		__entry->irq_num = q->irq_num;
> > +		__entry->curr_cpu = get_cpu();
> > +		__assign_str(qname, q->name);
> > +		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
> > +		__assign_bitmask(irq_affinity, cpumask_bits(&q->affinity_mask),
> > +				 nr_cpumask_bits);
> > +	),
> > +
> > +	TP_printk("i40e_napi_poll on dev %s q %s irq %d irq_mask %s curr_cpu %d "
> > +		  "budget %d bpr %d work_done %d tx_work_done %d "
> > +		  "clean_complete %d tx_clean_complete %d",
> > +		__get_str(dev_name), __get_str(qname), __entry->irq_num,
> > +		__get_bitmask(irq_affinity), __entry->curr_cpu, __entry->budget,
> > +		__entry->budget_per_ring, __entry->work_done,
> > +		__entry->tx_work_done,
> > +		__entry->clean_complete, __entry->tx_clean_complete)
> > +);
> > +
> >  /* Events related to a vsi & ring */
> >  DECLARE_EVENT_CLASS(
> >  	i40e_tx_template,
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > index ed88309..8b72f1b 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -2743,6 +2743,9 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
> >  			clean_complete = false;
> >  	}
> >  
> > +	trace_i40e_napi_poll(napi, q_vector, budget, budget_per_ring, work_done, tx_wd,
> > +			     clean_complete, tx_clean_complete);
> > +
> >  	/* If work not completed, return budget and polling will return */
> >  	if (!clean_complete || !tx_clean_complete) {
> >  		int cpu_id = smp_processor_id();
> > -- 
> > 2.7.4
> > 
