Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AB7639121
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiKYVek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKYVej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:34:39 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E5824BD1;
        Fri, 25 Nov 2022 13:34:38 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 4B05781546;
        Fri, 25 Nov 2022 21:34:36 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669412078;
        bh=MWyPOqNhcy4om47xZgvYks/+BmA3zNe3/a3Snv1f9DM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Xgg3C/NXLWcM3hFSl0Z93A2fprbUtnLJoK/4hEaVTSKaTnogUMTrZX64H3K7d9O58
         ZtyrInV6hCW/+afxfxCtigzvL6x2SOO0y25xaH1S/dqdFZ/YrkXet/wc2HJILcauT0
         WWHClt3kbpI+ieRWMysrzKF4xxk3m/cJ7d3boxy+n3CptCoQ6V8Ytx0YdkQQqJ7/gf
         V8wjIxW9MMQ3kF08B9QjRDS7dnWSeYX1864568r5s881uCSDcGIsFeOtZ7E6m0A5PP
         pJ3Pji/4xYVP6MJbfMHdgLNv/nsmSPbcQfYPzn6QJ9d56ouimeSGElja3WPuraREZD
         /7PPivKR5CMvA==
Message-ID: <4df015bc-b163-ed6d-2490-38b592432b82@gnuweeb.org>
Date:   Sat, 26 Nov 2022 04:34:33 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 3/4] liburing: add example programs for napi busy poll
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221121191459.998388-1-shr@devkernel.io>
 <20221121191459.998388-4-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221121191459.998388-4-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 2:14 AM, Stefan Roesch wrote:
> This adds two example programs to test the napi busy poll functionality.
> It consists of a client program and a server program. To get a napi id,
> the client and the server program need to be run on different hosts.
> 
> To test the napi busy poll timeout, the -t needs to be specified. A
> reasonable value for the busy poll timeout is 100. By specifying the
> busy poll timeout on the server and the client the best results are
> accomplished.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

Also, please fix your indentation. You have random indentation all
over the places.

   Applying: liburing: add example programs for napi busy poll
   .git/rebase-apply/patch:258: space before tab in indent.
           	avgRTT += ctx->rtt[i];
   .git/rebase-apply/patch:322: trailing whitespace.
   	int flag;
   .git/rebase-apply/patch:346: space before tab in indent.
                   	opt.sq_poll = true;
   .git/rebase-apply/patch:382: space before tab in indent.
           	fprintf(stderr, "inet_pton error for %s\n", optarg);
   .git/rebase-apply/patch:391: space before tab in indent.
           	fprintf(stderr, "socket() failed: (%d) %s\n", errno, strerror(errno));
   warning: squelched 6 whitespace errors
   warning: 11 lines add whitespace errors.

-- 
Ammar Faizi

