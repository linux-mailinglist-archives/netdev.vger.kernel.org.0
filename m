Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84BB04CE2A2
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiCEFDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCEFDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:03:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EA026ACD
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 21:02:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B47B82C7C
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 05:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463C2C004E1;
        Sat,  5 Mar 2022 05:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646456543;
        bh=/E01gvTHB1eMauPYX40FIJFX6VN8jkua09zAs1iV5EA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IACl7A5Va5biOKcFzNI2bTSqzWEWssE2/2b+3Kh+0IAvaOhFIEbsYC5CSOmbOyG+k
         vKipRiWxg4jVapgt8UAhhcV5LW0SikMj6VjspeIT/Y6ThVq68VyB5ZiAkrvg7pmfhK
         ugimGe85HSZ/IRy9kGM5vxiXrzGmkMDFa5zBwNN31fMSTrZz6BrXKCYkORwfFGCqdn
         qWyrrWKjuTLhMp97RQembYu9sW50ZjCtAHtvIuuIVuoNjKsVE6N+qN9svkG+0W8t8k
         RT7eebNTPUN6claMnK1sKIwj4j7TmXq9HyfpA6fIJrvRfHPI8rluoZw/Z9SUvG4vGm
         uGl7YLHENPb9g==
Date:   Fri, 4 Mar 2022 21:02:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [RESEND PATCH net-next] ptp: ocp: correct label for error path
Message-ID: <20220304210221.02b5f0ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220304054629.1795-1-jonathan.lemon@gmail.com>
References: <20220304054629.1795-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 21:46:29 -0800 Jonathan Lemon wrote:
> -		gto out_unregister;

The git send-email deities are not on your side, it seems.
Something ate an 'o' there.

> +		goto out_free;
