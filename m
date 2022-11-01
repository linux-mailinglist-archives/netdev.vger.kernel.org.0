Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5853614BE5
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 14:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiKANkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 09:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiKANj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 09:39:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE4ADE9D;
        Tue,  1 Nov 2022 06:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF89C612BF;
        Tue,  1 Nov 2022 13:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5AEC433D6;
        Tue,  1 Nov 2022 13:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667309996;
        bh=tU/xIR2OTXSfauLcL7TpKoY+jWkN0mOWVHlaaWgz/xQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=cFSFZQDStSSmAPzqzz1lg2yfBq0pgyH4lKkLpwFwnAiWWn+IoBFuw4yZ3MH3A1oSB
         m2Tmxc4RdwvY/o/1xTHMkDp4EVkz55ZhjvXojHM+QjbQ/LXnAUSdZMGWvEtrdR/A99
         Hl1FI69IF2PuzygQPJ8Kq7KXym1hq4jfyVlUmpyG7gQUK4GnSovYGSp9Drkj58uEK7
         aGfLhI8E3Rbb6c478zWuX33Zo1BbkBpFuxo+Bg8MrHkSg1WYM+upoSMrpNIhf+xgEJ
         EGDD/pvvb4BaaKEV44HHZy1g9r9tNikOiraUf1Cje0qsjWWZWiFovtnQD31+ko7Eq+
         2RsXNbhZfBqiQ==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: Linux 6.1-rc3 build fail in include/linux/bpf.h
In-Reply-To: <87wn8fszw4.fsf@all.your.base.are.belong.to.us>
References: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
 <Y1+8zIdf8mgQXwHg@krava>
 <Y1/oBlK0yFk5c/Im@hirez.programming.kicks-ass.net>
 <Y2BD6xZ108lv3j7J@krava> <87wn8fszw4.fsf@all.your.base.are.belong.to.us>
Date:   Tue, 01 Nov 2022 14:39:53 +0100
Message-ID: <87iljyyes6.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> writes:

> Jiri Olsa <olsajiri@gmail.com> writes:
>
>> tests work for me..  Toke, Bj=C3=B6rn, could you please check?
>
> Awesome! Much nicer!=20
>
> For Peter's patch, feel free to add:
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

FWIW, I tested on commit 5aaef24b5c6d with dbe69b299884 ("bpf: Fix
dispatcher patchable function entry to 5 bytes nop") reverted, and
Peter's patch applied.
