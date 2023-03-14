Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66C96B86DE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCNA1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNA1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:27:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543507DFAD;
        Mon, 13 Mar 2023 17:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02410B81690;
        Tue, 14 Mar 2023 00:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376E2C433EF;
        Tue, 14 Mar 2023 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678753659;
        bh=aYzPRSwIRsgKjKjCSMcQS/WUymy+zYQ+d+Ttuiy3kkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HccrvcwmUv4748YrOZTuRhEICineiYDDjgOsR11VUJz+i5LehYQumkS0lI30JqY85
         rPDcX+BsrwGkQaDw2etnRtclvudVirtaFrtQlBso2w3XMdu7KqWBRfPzqR/vqk71uq
         TQhTlPageCZSw+fBknGJhF/cLlYrsBnvfnnLrNoeKuRLfWFO9WKbqk1tHZY2AZLb2k
         KELbwsgR5jx3H/HcfyfcKyO07DvlqHS/yXWO2TPTY9tuTLllVn1tnf8VTweceCxG8A
         74YBLn3YGH5EjMRAufMkTaIrWoAF5dsSWwH/m+tD0we0SMuMBSXGuu0/OX9Ufbd1CQ
         mAPtavf2ciDsA==
Date:   Mon, 13 Mar 2023 17:27:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
Subject: Re: [PATCH net-next v2 0/9] net: sunhme: Probe/IRQ cleanups
Message-ID: <20230313172738.3508810f@kernel.org>
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Mar 2023 13:18:56 -0500 Sean Anderson wrote:
> Well, I've had these patches kicking around in my tree since last October, so I
> guess I had better get around to posting them. This series is mainly a
> cleanup/consolidation of the probe process, with some interrupt changes as well.
> Some of these changes are SBUS- (AKA SPARC-) specific, so this should really get
> some testing there as well to ensure nothing breaks. I've CC'd a few SPARC
> mailing lists in hopes that someone there can try this out. I also have an SBUS
> card I ordered by mistake if anyone has a SPARC computer but lacks this card.
> 
> I had originally planned on adding phylib support to this driver in the hopes of
> being able to use real phy drivers, but I don't think I'm going to end up doing
> that. I wanted to be able to use an external (homegrown) phy, but as it turns
> out you can't buy MII cables in $CURRENTYEAR for under $250 a pop, and even if
> you could get them you can't buy the connectors either. Oh well...

Doesn't apply to net-next, please note we're using the branch called
*main* now.
