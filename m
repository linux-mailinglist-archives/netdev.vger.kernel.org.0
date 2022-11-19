Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884D66308A3
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiKSBph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiKSBpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:45:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9E0776C4;
        Fri, 18 Nov 2022 17:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7C362815;
        Sat, 19 Nov 2022 01:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB23C433D6;
        Sat, 19 Nov 2022 01:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668820017;
        bh=N577Lrx7rpjpDEzTazxsex2uDBhZFoqI49/5l4f/DHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UaeLo4M4BC2gptno4GeY0D3B6ZzM81r2Nsj5no2KaTklP99m5OAE4uVP51U3ccEb8
         9ZcQCUlqltcxWJNmAS+L+AGimVzXXfSBvqe6brpOvmva54APCttmQ6aoF9ixz0Y6wf
         jXjIdLTibbQflheOEAfaEAkcF4NUXaLXM6QV2ibd6IgU6qfeh4NZmzIsof6WGSN0Qw
         MdhnmQuvWETfZKgcTH/SZDh+uQQAPpORrmb7KRVEQxAfPKC90GsYNIkbDFBWBLZmKK
         nyMvhAb664+HpkAVXoQpY0BnSNt8PS5SPB3A90XwsnDvE9fZNS+TTT7xFTOk8GKIA4
         qYTUpaxuknjJQ==
Date:   Fri, 18 Nov 2022 17:06:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] veth: a couple of fixes
Message-ID: <20221118170655.505702e5@kernel.org>
In-Reply-To: <87pmdky130.fsf@toke.dk>
References: <cover.1668727939.git.pabeni@redhat.com>
        <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
        <87pmdky130.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022 12:05:39 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> FWIW, the original commit 2e0de6366ac1 was merged very quickly without
> much review; so I'm not terribly surprised it breaks. I would personally
> be OK with just reverting it...

+1
