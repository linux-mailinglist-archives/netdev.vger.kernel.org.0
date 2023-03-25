Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080516C8AC0
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCYD51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCYD50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620F814EA1;
        Fri, 24 Mar 2023 20:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F4361F2E;
        Sat, 25 Mar 2023 03:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A1FC433D2;
        Sat, 25 Mar 2023 03:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679716644;
        bh=hU5WNx8UW3hzSvZ1SqKJ7lKWMuzum/quQ1Npov6M36M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TVT0xSK57BvUbJfmVr4a+zj5agVXghvvtYdAUWquBGMCNUng7n0lP+mqfi/XeacK3
         MGjyMgHqorYJ9yXtzHaoWeFc8mW1aAex5/j0Lb0V3HN+jNKFgr/WB6g3wHLAHn9m9J
         Qegr2LR02BzOTS/2auvoYot1ab1kwZHH+aTnAiT5xyurtDTM29hnIHL3z8hiDoMqJB
         T36JyEyufWgW5VAYs0bugOwcnEt90trqIKYm5NJkAsbMTE12BsQyOn62Zz4SCxgw1k
         bnj7aj8Iehk56gQqf3dwyttncz4bQcdTbYDCGsldd9A3RjdrBTlCMz84y+SKCRs3n3
         envcw1SE5aU+Q==
Date:   Fri, 24 Mar 2023 20:57:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 7/7] docs: netlink: document the sub-type
 attribute property
Message-ID: <20230324205722.7b6a9e70@kernel.org>
In-Reply-To: <20230324191900.21828-8-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-8-donald.hunter@gmail.com>
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

On Fri, 24 Mar 2023 19:19:00 +0000 Donald Hunter wrote:
> +sub-type
> +~~~~~~~~
> +
> +Attributes can have a ``sub-type`` that is interpreted in a ``type``
> +specific way. For example, an attribute with ``type: binary`` can have
> +``sub-type: u32`` which says to interpret the binary blob as an array of
> +``u32``. Binary types are described in more detail in
> +:doc:`genetlink-legacy`.

I think sub-type is only used for arrays? How about:

 Legacy families have special ways of expressing arrays. ``sub-type``
 can be used to define the type of array members in case array members
 are not fully defined as attributes (in a bona fide attribute space).
 For instance a C array of u32 values can be specified with 
 ``type: binary`` and ``sub-type: u32``. Binary types and legacy array
 formats are described in more detail in :doc:`genetlink-legacy`.
