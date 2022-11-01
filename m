Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA19614A7D
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiKAMRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiKAMRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:17:41 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685C915823;
        Tue,  1 Nov 2022 05:17:40 -0700 (PDT)
Date:   Tue, 1 Nov 2022 20:17:34 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667305058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4j6en4OnnOMWAFGjdM+2FAAFoCtXEIZdWP3Ak+M95o=;
        b=KCsBTAbWkhDfat47Kg37QkKi0uXphRSr3nleVgjOwAwc7ygKJ5lEeUIzzfI4sket9sNJIY
        NjUiRut3Hg1ue+KhohTKtLeKLZ5vurbOWNrTGv7Fc/Huwlt1Peh707KJ9I9GuJo0Nj8K/i
        ZCdHN5cgqlLM6vPT6MKF3063dDejZSs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     kuba@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        SeongJae Park <sj@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: hinic: Add control command support
 for VF PMD driver in DPDK
Message-ID: <20221101121734.GA6389@chq-T47>
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
 <20221101060358.7837-2-cai.huoqing@linux.dev>
 <87iljz7y0n.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87iljz7y0n.fsf@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 11月 22 12:46:32, Jani Nikula wrote:
> On Tue, 01 Nov 2022, Cai Huoqing <cai.huoqing@linux.dev> wrote:
> > HINIC has a mailbox for PF-VF communication and the VF driver
> > could send port control command to PF driver via mailbox.
> >
> > The control command only can be set to register in PF,
> > so add support in PF driver for VF PMD driver control
> > command when VF PMD driver work with linux PF driver.
> >
> > Then there is no need to add handlers to nic_vf_cmd_msg_handler[],
> > because the host driver just forwards it to the firmware.
> > Actually the firmware works on a coprocessor MGMT_CPU(inside the NIC)
> > which will recv and deal with these commands.
> >
> > Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> 
> Out of curiosity, what exactly compelled you to Cc me on this particular
> patch? I mean there aren't a whole lot of places in the kernel that
> would be more off-topic for me. :)
run ./scripts/get_maintainer.pl this patch in net-next
then get your email
Jani Nikula <jani.nikula@intel.com> (commit_signer:1/8=12%)
Maybe you have some commits in net subsystem ?
> 
> BR,
> Jani.
> 
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center
