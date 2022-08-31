Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28C85A8727
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiHaT6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiHaT6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:58:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2740DEEF0E;
        Wed, 31 Aug 2022 12:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A42CB822DC;
        Wed, 31 Aug 2022 19:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADFAC433D6;
        Wed, 31 Aug 2022 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661975927;
        bh=sm71GH8RVOSxlkmJw9DILKfIbjQQHhnDtzuUCa7a+A0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vej9rMn33tgVQT64mL5+CPKnapndlNftAjpvlda+Pz3I9N+p+I/q14iTsqJx976q4
         eevdCgu1CrjQ0B5kqPbvsmoXek9099Vn80KOK2HUGQ4+kb65ogp22XWZ9fHURNmGdN
         Ekch00ehgnJ85hzsTFx92en+IX6gh/JWuwXekQblocAfMAi9M9EdLcjyOl8EKnKgxC
         vYwIELkJ/aVmfPd4lmrICTdPLU9Ez7XQTLAoaVIrxSWHy4C1a05XgSeeMG3uX93L/B
         0ZpoA+++LJGJnUep8F/+u403I2aqcb3/zT/lnk0kSrNUql9cuG6Me59pPeePL59v1M
         ag+Onf8Noz9gQ==
Date:   Wed, 31 Aug 2022 12:58:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn
Subject: Re: [PATCH v3 0/3] Namespaceify two sysctls related with route
Message-ID: <20220831125846.6bb2983a@kernel.org>
In-Reply-To: <20220830091453.286285-1-xu.xin16@zte.com.cn>
References: <20220830091453.286285-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 09:14:53 +0000 cgel.zte@gmail.com wrote:
> With the rise of cloud native, more and more container applications are
> deployed. The network namespace is one of the foundations of the container.
> The sysctls of error_cost and error_burst are important knobs to control
> the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
> containers has requirements on the tuning of error_cost and error_burst,
> for host's security, the sysctls should exist per network namespace.
> 
> Different netns has different requirements on the setting of error_cost
> and error_burst, which are related with limiting the frequency of sending
> ICMP_DEST_UNREACH packets. Enable them to be configured per netns.

One last time, if v6 doesn't need it, neither should v4.

Seems like you're just trying to check a box.

I'm dropping these patches from patchwork, please don't repost them
again, unless someone from the community voices support for merging
them.
