Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477AD554223
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356052AbiFVFMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiFVFMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:12:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6A035DD6
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89655CE1BE7
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5E5C34114;
        Wed, 22 Jun 2022 05:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655874762;
        bh=/lesbGgs8AZN7bIWRDinpqqufD5otPXlqOO+QKEMdPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dgfn9jZgLsnYtuhb4MvnZ9JhfdPwXw62lt152VyWtyywqcr0qvEdqaz1MErEcC78I
         yEFVZaYnpGVgLlD0k/AohulUfzrllUpkijGg6oqj5+7YZyLQHH2sMXj9zhAK3acvF3
         zAkpww4/qs16Ef4dSpvGGOyyO0THRl7aTe4pYYq3+h0Rw29V59qGTsZIvlta6YwZwI
         NSAwY+HWtP2D9evFRI1OPnFEdb3eGSV1GT2HpRUpupxlgcZXNH7RcjwU8tUbjcCuaW
         AGguBVvBPdhZeEPKNLZf/B2wuEv7G3zY3IWh7W5Ivju0j7AbsPAtwSD7dpPEGhnmOi
         yTYPQplq2/GOw==
Date:   Tue, 21 Jun 2022 22:12:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: helper function for skb_shift
Message-ID: <20220621221240.36c6a3a6@kernel.org>
In-Reply-To: <20220620155641.GA3846@debian>
References: <20220620155641.GA3846@debian>
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

On Mon, 20 Jun 2022 17:56:48 +0200 Richard Gobert wrote:
> Move the len fields manipulation in the skbs to a helper function.
> There is a comment specifically requesting this and there are several
> other areas in the code displaying the same pattern which can be
> refactored.
> This improves code readability.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>

That's better, thanks. Please move the helper to skbuff.h
and consider changing the subject from talking about skb_shift() 
which is just one of the users now to mentioning the helper's name.
