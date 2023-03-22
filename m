Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574BF6C53B1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjCVSZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCVSZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B530C14E83
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:25:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E66D6226E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F30FC433D2;
        Wed, 22 Mar 2023 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679509525;
        bh=b4kEjvu7HgMOG5iIYWypdREsGmNFAuqqJL82NnP/JNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ohk8ecv4BciG/tWfQ4YevPzv3I+TWt4TzxmEii1eA5uyCqDSQkf+VUldixmm+wr3i
         UQe2jlLVaxaUqUpeONP2iJWOhZQjV3egjGadaCombe/kQNBL/9lelPDH1meXQM7tXx
         Ls/ywQ+wFitwI6vpoRLHqDhRgzBgSlMubQ1wt1TpBr2dh0N7HVAV9tQQUF94fhp8jg
         KBnKvcCStoUvgHd2jdeBZlB4CfWaVrP+cGsf5vYdFvwrSiuuDwM8o12Q9q+P/8wL3v
         qyzG2uJHTzLfquj6zc7GhLS7Od5mnjmx8UB2rB8WWQZ1+l/MHkgWPqwKnX5iOon3bl
         22oZ+hnF7Jgcw==
Date:   Wed, 22 Mar 2023 11:25:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 2/6] tools: ynl: Add struct parsing to
 nlspec
Message-ID: <20230322112524.0d44b94f@kernel.org>
In-Reply-To: <m2bkklj9t2.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-3-donald.hunter@gmail.com>
        <20230321222245.48328d8b@kernel.org>
        <m2bkklj9t2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 11:38:01 +0000 Donald Hunter wrote:
> >> +    Attributes:
> >> +        type    string, kernel type of the member attribute  
> >
> > We can have structs inside structs in theory, or "binary blobs" so this
> > is really a subset of what attr can be rather than necessarily a kernel
> > type?  
> 
> Okay, so the schema currently defines the member types as u*, s* and
> string. Does it make sense to add 'binary' and 'struct'?

We don't have to until it's needed.

> To be clear, do you want me to drop the word 'kernel' from the
> docstring, or something more?

Removing kernel should be good enough
