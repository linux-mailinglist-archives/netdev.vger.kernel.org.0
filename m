Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EAD4C0652
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiBWAnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbiBWAnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:43:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31ABAFD0B
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 16:43:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0344B81D91
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED22C340E8;
        Wed, 23 Feb 2022 00:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645576998;
        bh=g4Doz2JgNKgoT+61VFj8Fq1SSiuvovtRPrRhRH4wn9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QZ2bJxjnUYqRLSf0T6LfjGiuq/nsqCfeMbFuyCnqE0T5QK+qdCyUVEi3i6iSHw6Ht
         NwtzR0/TzTRCxRRApGW9RfmXhuh7VFYykpS3KDGoNWQFzCetCH2gYWktxWujujCPEB
         yVlqwod8j3vH9GFC+nXnyq9tpobBoBNCJcXybavKlYMkpTKtZtf/5yIqarYlLFXTk7
         +hyf3ffMdU8cg2EdHKipQNz2l/necDJJocNxHRYWyTspw16t5GVF+2KCCF6e32UpG/
         lWTD/cG2INKfu6x0ZByZMNTdswoLkUb8SW6Ytc8MkzSFQ6ue+piaA+e4XrgN+2ah3h
         4OEtFPxOvVgtw==
Date:   Tue, 22 Feb 2022 16:43:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niels Dossche <niels.dossche@ugent.be>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv6: prevent a possible race condition with lifetimes
Message-ID: <20220222164317.4c7f6bcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5599cc3b-8925-4cfd-f035-ae3b87e821a3@ugent.be>
References: <5599cc3b-8925-4cfd-f035-ae3b87e821a3@ugent.be>
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

On Sun, 20 Feb 2022 18:54:40 +0100 Niels Dossche wrote:
> valid_lft, prefered_lft and tstamp are always accessed under the lock
> "lock" in other places. Reading these without taking the lock may result
> in inconsistencies regarding the calculation of the valid and preferred
> variables since decisions are taken on these fields for those variables.
> 
> Signed-off-by: Niels Dossche <niels.dossche@ugent.be>

Looks like your email client has replaced tabs with spaces, 
so the patch won't apply. Could you try resending with git send-email?
Please add Dave's review tag in the next version, and the subject
tag should be [PATCH net v2]. Thanks!
