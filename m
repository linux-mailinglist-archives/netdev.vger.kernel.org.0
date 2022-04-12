Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BC84FE513
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357289AbiDLPtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357309AbiDLPta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:49:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51B56005F
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C515B819FD
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 15:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A94EC385A5;
        Tue, 12 Apr 2022 15:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649778420;
        bh=4zMV9F3FChIO+lD2MsMpUwisXBjI9AH8/81Vgqxi69k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kywpsU0w7OPWcEdJvgXomyntHbzChpaBm8bF9RjmoD3HWTsYDPYKW5tvj9d02ptef
         d+XHHbVrFMVSRcc0EPRg0UttyQ89p2V3bdJBDXfobd4ycvsDeXwpz32xPN8JdCAodI
         7lEPuDVYPtZnz9s/f7yk95rIl4L64KCsQNc1lwimZGySvCKExUyB6McqpK1EGQTeKw
         tq8M7Gx116d9qg2cgVXwcDWgvx7CSWU2aEKMlQpekXisMZCNXVg8JmnDXKXsVjgHim
         gMwfwAtjfC7B7LNP6/fTv68oUIVSLzuZlPa+EYqLEW4C4FeN4iJRkiACEzvL0sE6Uk
         6GzU2dCa7TNSA==
Date:   Tue, 12 Apr 2022 08:46:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>,
        Dylan Muller <dylan.muller@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next] nfp: update nfp_X logging definitions
Message-ID: <20220412084659.60838d73@kernel.org>
In-Reply-To: <20220412152600.190317-1-simon.horman@corigine.com>
References: <20220412152600.190317-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 17:26:00 +0200 Simon Horman wrote:
> From: Dylan Muller <dylan.muller@corigine.com>
> 
> Previously it was not possible to determine which code path was responsible
> for generating a certain message after a call to the nfp_X messaging
> definitions for cases of duplicate strings. We therefore modify nfp_err,
> nfp_warn, nfp_info, nfp_dbg and nfp_printk to print the corresponding file
> and line number where the nfp_X definition is used.
> 
> Signed-off-by: Dylan Muller <dylan.muller@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Examples? The messages are usually unique. Unless you also print 
the kernel version the line numbers are meaningless in real life.
