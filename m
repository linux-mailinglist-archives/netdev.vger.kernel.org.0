Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F4C4EB941
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbiC3ETV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiC3ETU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:19:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A17A23454B;
        Tue, 29 Mar 2022 21:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B92C5B81B2F;
        Wed, 30 Mar 2022 04:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FC5C34111;
        Wed, 30 Mar 2022 04:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648613852;
        bh=QF70sGA2dTEZu1WjPvyP1I8S4BZZv+sAiFS9irFzaQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9rTMwpzathH9iBCgP7eZ3mHn4nnccuQhWyFckzOxSsP20l3ezdDkwpxGhX4PMqN4
         oHZgTXQmF5cKVRA52N/pRGLajE2dm6tGcXF18GTF920YVQt2Q36nnTGHcwbCAG0HeD
         acXM9NCRzrS6p5Q94v5zXTZ45Z9Y12ZfQq28nxZ1kSkK7H1it88UMHk0+1TMJY8Dyb
         ty8MuGbXNEAona+jLj5jyK4DNfX60R1B9KltH/w48yBgJTnm0npFS3XPCN3MAyIJgy
         wwSyWUd6G7ZS/xERn8+DiNI64ORucWRcBsaK9mpH6bwhUYc1PbMiPaCoN28uyFpxLj
         Dkr+Fo+PvErLA==
Date:   Tue, 29 Mar 2022 21:17:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH net v2 07/14] docs: netdev: rephrase the 'Under review'
 question
Message-ID: <20220329211730.71024b45@kernel.org>
In-Reply-To: <6c1836e4-0ac1-a743-5b91-c6b1867b8338@gmail.com>
References: <20220329050830.2755213-1-kuba@kernel.org>
        <20220329050830.2755213-8-kuba@kernel.org>
        <6c1836e4-0ac1-a743-5b91-c6b1867b8338@gmail.com>
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

On Tue, 29 Mar 2022 20:33:05 -0700 Florian Fainelli wrote:
> > -48h).  So be patient.  Asking the maintainer for status updates on your
> > +48h). But be patient, if your patch is active in patchwork (i.e. it's
> > +listed on the project's patch list) the chances it was missed are close to zero.
> > +Asking the maintainer for status updates on your
> >   patch is a good way to ensure your patch is ignored or pushed to the
> >   bottom of the priority list.  
> 
> I would reword that at some point, this feels a little bit retaliating.

Let me drop the last sentence, we can always at it back if people start
pinging us.
