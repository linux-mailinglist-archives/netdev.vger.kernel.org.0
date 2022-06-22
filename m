Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14EF554F79
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358324AbiFVPh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357795AbiFVPhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:37:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94E13BA48
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E9A16167B
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 15:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269E1C34114;
        Wed, 22 Jun 2022 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655912240;
        bh=fEAGa4ngnzUj+HN89ESB5vXGyNrhQwt93Q2I5TyfhhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iZYRspFnSxPENe6ndNi7Fmffofa7eRXsT9MqwdSjcpg7/t/jLAVsV1ASM+USOmWmx
         E8pPhXPZAO730xwTPlwPCvms3QDt8NB/3bxyLQi/uqoKkJ6AmbNjSyLBHrcKgiQUs2
         rN6in6T/WwiX2kgJlVxhE+DabS3sdWvK8IxhafKj6klYpN80BU8HLYaFssLrMktSA0
         qd2uviKgFfPXjinX4LzV/Qrt+KlKSqB8OF2BaPEpAQ+yC1+1FR2bMJPvDh85COj+PS
         OjrFYoCLY9OqoHImNEgts1QY3GGn7NghJeqbqGuaQwInWxXP/bxmLeA/McVOQMHoXK
         izrPe+89cE/xA==
Date:   Wed, 22 Jun 2022 08:37:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: helper function for skb_shift
Message-ID: <20220622083719.13af304a@kernel.org>
In-Reply-To: <20220622102517.GA4171@debian>
References: <20220620155641.GA3846@debian>
        <20220621221240.36c6a3a6@kernel.org>
        <20220622102517.GA4171@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 12:25:20 +0200 Richard Gobert wrote:
> On Tue, Jun 21, 2022 at 10:12:40PM -0700, Jakub Kicinski wrote:
> > and consider changing the subject from talking about skb_shift() 
> > which is just one of the users now to mentioning the helper's name.  
> 
> When submitting the updated patch with a new subject, should it be marked v3
> or is it considered a new patch entirely?

v3 is better, that way maintainers will know to look for a previous
version to check if feedback has been addressed.
