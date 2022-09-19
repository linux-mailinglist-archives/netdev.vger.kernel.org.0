Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3E25BD22B
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiISQ00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiISQ0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FE53BC67;
        Mon, 19 Sep 2022 09:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15F0F61CB5;
        Mon, 19 Sep 2022 16:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EC5C433D6;
        Mon, 19 Sep 2022 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663604779;
        bh=GEVvAvyI/hHU9fJ2oHImIrs/eG+bedF5ZoBg+wnMo5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JUILebco6Nisehy+DDDzAVyyI3jxjKDfbujC9vky4fbFbCegWUQRq6J0wAT/DGR/6
         rm+zVGV9md9tWE8sg9W++G4bfiiiv8edGy9+2JG9NolEwfncVUKGK94FCM8zSNHy4L
         enITyFx12yfE2clj+pB0l+RZvMy5awJ2nfzinLQeRvrLL8qIRKkuEblLXBRREsq6N2
         l/KMmS4rxV2Y1bG1ZG8FKZW5+Gc5Dc2NUenr0PdWNvumfaZDG+4IHIatyuspH1uRkC
         B09ixDjt/qDlWo36FOMLdBLmT1vYXeDkwbktYdQV1ugiMwairQtZ6/54wz+CkIAj5W
         Jw21ZLYZWI3xg==
Date:   Mon, 19 Sep 2022 09:26:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        ast@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: pull-request: bpf-next 2022-09-05
Message-ID: <20220919092618.146f47a3@kernel.org>
In-Reply-To: <20220905161136.9150-1-daniel@iogearbox.net>
References: <20220905161136.9150-1-daniel@iogearbox.net>
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

On Mon,  5 Sep 2022 18:11:36 +0200 Daniel Borkmann wrote:
> 1) Add any-context BPF specific memory allocator which is useful in particular for BPF
>    tracing with bonus of performance equal to full prealloc, from Alexei Starovoitov.

The MM folks basically acquiesced that this is BPF-specific 
and does not concern them? Would had been great to squeeze 
an ack out of someone.
