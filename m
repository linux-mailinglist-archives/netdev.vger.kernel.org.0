Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A775A55CB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 22:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiH2Uwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 16:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiH2Uw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 16:52:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09777C1FE
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 13:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17F28611B8
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 20:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C3FC433D6;
        Mon, 29 Aug 2022 20:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661806347;
        bh=bWuiZPbqUlIN8mvv83ojiORsZudBcAwk+djT6z6SKt8=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=aJW/GKUmtw8TZ+PznVJIqWcwYoNkOFLWuMgM/qvVz5AYD4IeuYyidj8WVwTOhfcBB
         OJzw8O+eX/66Gw0dNMUevEmyf+SqFUopKnMa8CCoRxBepsWgrp9PaHlr0oitCWdXDb
         gXDT8BJlowck53PR2ltDhojt/s693YK6iQzGZjBq5sGtZpwdyEDo7g3tAtwSA3IKhR
         dwPt7LZN48QpwZc6Le4g57JfTvElFMA5HMxaZWQxjvUN9ApqpE94WG5LsKOt9b70jM
         AdfH8okjMeCMM77wJHb9PjgGk3BCufEFYqZGheMQgPlOakYsv8PJDJw1PAGJjRO66a
         73ol+QPzDeW7Q==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D8E24588811; Mon, 29 Aug 2022 22:52:24 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Thorsten Glaser <t.glaser@tarent.de>, netdev@vger.kernel.org
Subject: Re: continuous REPL mode for tc(8)
In-Reply-To: <33c27582-9b59-60f9-3323-c661b9524c51@tarent.de>
References: <33c27582-9b59-60f9-3323-c661b9524c51@tarent.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Aug 2022 22:52:24 +0200
Message-ID: <87sfle6ad3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thorsten Glaser <t.glaser@tarent.de> writes:

> Hi,
>
> perhaps, if not inter-qdisc communication, can I at least have
> a mode for tc to run in a loop, so I lose the fork+exec overhead
> when calling tc change a *lot* of times?
>
> How difficult to implement is that?

It already exists; see the '-b' option (RTF man page for details) :)

-Toke
