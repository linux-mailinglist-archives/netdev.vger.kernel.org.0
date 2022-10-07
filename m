Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5465F7C77
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJGRtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJGRtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:49:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332F4D2583
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 10:49:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n18-20020a17090ade9200b0020b0012097cso4265788pjv.0
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 10:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XG9g33SnkGf5SeuOOfR6UeSRihhRnU6omjZODWjTdks=;
        b=Mc+iEZYlqVQV9bQD+iWlSflT0KNxmISO2o9IyswsPRugH0auvUrIIMtKcHVsJi1cLs
         aGb8bNGzIRbAydei+5yR3p71SDar0aodsxc2SYjKzNCBaZf6veqVPWnsikBa14aZgqUP
         zlyjFO95HIulRGkwL/a4zAbcM5wnsTNLlW3D8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XG9g33SnkGf5SeuOOfR6UeSRihhRnU6omjZODWjTdks=;
        b=zTQL+XZzMIw8svqbG/1teJT8z7HKkPt6Vsf70DZ11LvnUkT+INlStQyfctxkppJX9n
         6OStmL36HMPLZ9S4mSDQrV+c3v3DnHI3iRSrATc8bQ+DXVs5bkymVLLTU42ABOWAGXT/
         xAq6vC9tRXi/q/gwBfusQ0Fa/yXD+b0hKvIXMdAjPKdKoKyPEBQTMWR4mTCpjMS5wC6t
         bFnMiZkTCfIda4HIrUBMDkL/HtCAnUQQuAIeyG032kAtG+gMytERInZvX3REtblza6fH
         2uR6HDrGI9AnngR8gs9q4mTeb/7MhjTHgc4XZqm1fnSfoiz+NvGt5ywKIn1Fa9x7GPZ8
         G/CA==
X-Gm-Message-State: ACrzQf2Aaflg6N80p5JTzo8UD5u8FMO4m1NCfN1C2lx2CWsifZzJ3SAW
        nprNomJQ2qXCVwzyEXAGYQhhAg==
X-Google-Smtp-Source: AMsMyM7b+DueZYiENGLJEhot/4h9GxQ88yfjp0/EUSY/7ZgXTqzZAaXvKt5pFYBKD4Pcv4xVb13iRQ==
X-Received: by 2002:a17:90a:bf84:b0:20a:d039:f1ea with SMTP id d4-20020a17090abf8400b0020ad039f1eamr6364493pjs.245.1665164957671;
        Fri, 07 Oct 2022 10:49:17 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id je17-20020a170903265100b00174abcb02d6sm1773340plb.235.2022.10.07.10.49.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 10:49:17 -0700 (PDT)
Date:   Fri, 7 Oct 2022 10:49:14 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anthony.l.nguyen@intel.com,
        jesse.brandeburg@intel.com
Subject: Re: [next-queue v3 4/4] i40e: Add i40e_napi_poll tracepoint
Message-ID: <20221007174914.GA1032@fastly.com>
References: <1665099838-94839-1-git-send-email-jdamato@fastly.com>
 <1665099838-94839-5-git-send-email-jdamato@fastly.com>
 <Yz/g4W9rnhLcBsrd@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz/g4W9rnhLcBsrd@boxer>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 10:18:41AM +0200, Maciej Fijalkowski wrote:
> On Thu, Oct 06, 2022 at 04:43:58PM -0700, Joe Damato wrote:
> > Add a tracepoint for i40e_napi_poll that allows users to get detailed
> > information about the amount of work done. This information can help users
> > better tune the correct NAPI parameters (like weight and budget), as well
> > as debug NIC settings like rx-usecs and tx-usecs, etc.
> > 
> > An example of the output from this tracepoint:
> > 
> > $ sudo perf trace -e i40e:i40e_napi_poll -a --call-graph=fp --libtraceevent_print
> > 
> > [..snip..]
> > 
> > 388.258 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth2 q
> > i40e-eth2-TxRx-9 irq 346 irq_mask
> > 00000000,00000000,00000000,00000000,00000000,00800000 curr_cpu 23 budget
> > 64 bpr 64 rx_cleaned 28 tx_cleaned 0 rx_clean_complete 1
> > tx_clean_complete 1)
> 
> So from AF_XDP POV I won't be using it as I would need some other
> information.
>
> As I said, we don't work on NAPI budget but rather with the
> free ring space and I don't get it here. tx_cleaned is also quite
> incorrect name to me for count of produced descriptors to Tx ring. I feel
> like it would be better to stub it for AF_XDP.
>
> As Jesse said previously we probably can followup with AF_XDP specific
> tracepoint with tx cleaned/tx transmitted/NAPI budget/AF_XDP budget (free
> ring space) if we find the need for it.
> 
> That's my 0.02$, I'm not going to hold this set or whatever, I'll leave the
> decision to Sridhar & Jesse.

I'll send the other patchset I've written and tested as an RFC which doesn't
touch anything in XDP at all and only adds the tracepoint in i40e_napi_poll only
if xdp is not enabled.

The code in that branch for i40e_napi_poll looks like this:

+	if (!i40e_enabled_xdp_vsi(vsi))
+		trace_i40e_napi_poll(napi, q_vector, budget, budget_per_ring, rx_cleaned,
+				     tx_cleaned, rx_clean_complete, tx_clean_complete);

The XDP functions are not modified to take any out parameters in that
branch.

In that case, anyone who cares about XDP (when I think about XDP, I feel
nothing, so that probably won't be me) can go back through and add their
own XDP related tracepoint as the 'else' branch and modify all the xdp
related functions and add (very precisely named) out parameters.

As far as I'm concerned: I submit this code simply because it's been very
useful for me to debug i40e performance and to tune settings and I thought
it might be helpful for others.
