Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42634573CD2
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiGMS42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbiGMS40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:56:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A082FFD9;
        Wed, 13 Jul 2022 11:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41F4261DB8;
        Wed, 13 Jul 2022 18:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB5BC34114;
        Wed, 13 Jul 2022 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657738583;
        bh=horUYRJu4L75hyURMcGYdLgNsX8H8mt9BCJYF7S/48o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qi1iy3s0onH95DCrXc3y+rAMM8+C89BtS8wM23W3glvTW0dVAwwuMmxF6+oCoOOme
         tdWl9vW8q580L0iFw08w2S2nLbmkkOBsEqLmU/jb4FEA0HQzASIsw8r3khOsw9zhee
         hPO99h1vtjVhw6toAdcbU2q0mv0fkAAMFLrqdIC/eMy40iOxbENUalbSDPqNp4s65t
         O5DJsCqNQefB8Cmk5NtBv3Odep9Ig4fzaAbEAR0XH9ayG7JOO0Q320NMVQ/MpJguXc
         7SOb0vaqpt6U5JyXX/ZzxYyhn9yUadSWuf1UExVy6Rs5aT9iPnutNoLXqUf2My43xy
         kFxRvvr+Uce6A==
Date:   Wed, 13 Jul 2022 11:56:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 0/1][RESEND] Fix KASAN: slab-out-of-bounds Read in
 sk_psock_get
Message-ID: <20220713115622.25672f01@kernel.org>
In-Reply-To: <20220713181324.14228-1-khalid.masum.92@gmail.com>
References: <20220713181324.14228-1-khalid.masum.92@gmail.com>
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

On Thu, 14 Jul 2022 00:13:23 +0600 Khalid Masum wrote:
> Using size of sk_psock as the size for kcm_psock_cache size no longer
> reproduces the issue. There might be a better way to solve this issue
> though so I would like to ask for feedback.
> 
> The patch was sent to the wrong mailing list so resending it. Please
> ignore the previous one.

What happened to my other off-list feedback?

I pointed you at another solution which was already being discussed -
does it solve the issue you're fixing?
