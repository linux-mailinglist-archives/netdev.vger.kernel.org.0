Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE096CF01F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjC2RGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjC2RGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:06:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFDB5BBE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1D0B823DE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 17:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C921C433D2;
        Wed, 29 Mar 2023 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680109559;
        bh=kIZ3/ki6JuYvdvGdQRWk8XN6PRBhJMl2mgQbLGs9tmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kJq0WN5YxjDqr81/AUBz2RrIvbcRBKaQjINPXYHoDxsMzZzC/HBFtq5csAq3v6C7H
         9XnqT+HbjB4TS09NkH4C/0CgiuB0axXddUe8mJGnAX0RhO4wOC0J4WS1p0BhEScOEc
         /GAhp04l0plZMKxfb/2rADFqj69H/EcSQkPndI0ESfAKn4DkQqfIaevKjpkOxSUVhE
         I8w+i+SVOP0huI7VR5GJKsXBZlp5ErCluniUbhMJeGwzCOevdfCQF10z11pjJSCxg/
         cuZDnvgEdZKIEZaX2nRAYTmFDod3htRNUgycF8+JB6AIWSTT6PZa7Iq3VIg6YqsDqA
         bna6aFXAHJgow==
Date:   Wed, 29 Mar 2023 10:05:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] devlink: Add port function attributes to
 enable/disable IPsec crypto and packet offloads
Message-ID: <20230329100557.40890e35@kernel.org>
In-Reply-To: <93f74c83-d2e9-3448-9f07-64214cc0f7f8@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
        <20230323102331.682ac5d6@kernel.org>
        <93f74c83-d2e9-3448-9f07-64214cc0f7f8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 09:42:51 +0200 Dima Chumak wrote:
> > Is it fine grained? How many keys can each VF allocate?  
> 
> When I referred to "fine grained" control, I was talking about the
> different types of IPsec offload (crypto and packet offload) in the
> software stack. Specifically, the ip xfrm command has sub-commands for
> "state" and "policy" that have an "offload" parameter. With ip xfrm
> state, both crypto and packet offload types are supported, while ip xfrm
> policy can only be offloaded in packet mode.
> 
> The goal is to provide a similar level of granularity for controlling VF
> IPsec offload capabilities, which would be consistent with the software
> model. This will allow users to decide if they want both types of
> offload enabled for a VF, just one of them, or none at all (which is the
> default).

Ack, please add a reference or explanation somewhere and fix
the posting.
