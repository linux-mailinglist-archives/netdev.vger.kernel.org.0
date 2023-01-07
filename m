Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF82660BC3
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbjAGCIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjAGCIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:08:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4B287909;
        Fri,  6 Jan 2023 18:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36758B81F47;
        Sat,  7 Jan 2023 02:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A69C433D2;
        Sat,  7 Jan 2023 02:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673057289;
        bh=YOhSAXZASQVBJLRh+DeORful98VTEWD8I1dvkZ37Cvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cYlZOYl2Bb1oVN9vGuL78O5EBV7p0ietplnI7xiglH25geruteNb+ith+yP7AWUGc
         jt/ImaTKXn+L2YATEc76xUvI/769Lu8Ehgy+WRBEJpYfxTiA0WlFwOhzSmQj2nfgVs
         PA7NuNKzrz5oxo6q7CxBQ3qQ9rQXdTOqhg6e8b1yHrEY3XvwycHcfWq5qBN1PxkyUr
         jIni9Nx8dclZUyPNRkDVejJBeD35OdwiKhmRDMW7bSFGbigTJGgjOVj2zae2ZXLyHe
         SZtz07BGkAlI315pzq5pvTcUVhayY8TBFSLESHreI+BTN5hvVteSssoFSW9CuRN55y
         9wvCNd6Gl2eVQ==
Date:   Fri, 6 Jan 2023 18:08:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org
Subject: Re: [PATCH net v2] af_unix: selftest: Fix the size of the parameter
 to connect()
Message-ID: <20230106180808.51550e82@kernel.org>
In-Reply-To: <8fb1a2c5-ee35-67eb-ef3c-e2673061850d@alu.unizg.hr>
References: <bd7ff00a-6892-fd56-b3ca-4b3feb6121d8@alu.unizg.hr>
        <20230106175828.13333-1-kuniyu@amazon.com>
        <b80ffedf-3f53-08f7-baf0-db0450b8853f@alu.unizg.hr>
        <20230106161450.1d5579bf@kernel.org>
        <8fb1a2c5-ee35-67eb-ef3c-e2673061850d@alu.unizg.hr>
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

On Sat, 7 Jan 2023 02:42:43 +0100 Mirsad Goran Todorovac wrote:
> > still doesn't apply, probably because there are two email footers  
> 
> Thank you for the guidelines to make your robots happy :), the next
> time I will assume all these from start, provided that I find and
> patch another bug or issue.

Ah, sorry, wrong assumption :S

Your email client converts tabs to spaces, that's the problem.

Could you try get send-email ?
