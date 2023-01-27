Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8541267DE8A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjA0HdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjA0HdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:33:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277D16332;
        Thu, 26 Jan 2023 23:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85651B81F98;
        Fri, 27 Jan 2023 07:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FFCC433D2;
        Fri, 27 Jan 2023 07:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804782;
        bh=jU3Cs9zLmll07aFt2hD5OAowkoOa3yd1i19yHqBSKd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yE/mKuS4NDxmcx0lSvqJPW6q+PyrbhxFzoeB0TVWheyRbmTt95EaKPpa2gojNXAvD
         7sTETj9A/4WeqNjOQdxaVY/LmDvFlyJ504ikz9/ar/mtdEImqJr9nrA3TyIwz9aKrO
         p47IX4MVBE3+qSbbGV2mdzc1BrZjj+IGJtOuAtRM=
Date:   Fri, 27 Jan 2023 08:32:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] i40e: Add checking for null for
 nlmsg_find_attr()
Message-ID: <Y9N+K5OPa9eBqxXn@kroah.com>
References: <20230126135555.11407-1-n.petrova@fintech.ru>
 <20230126135555.11407-2-n.petrova@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126135555.11407-2-n.petrova@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 04:55:55PM +0300, Natalia Petrova wrote:
> The result of nlmsg_find_attr() 'br_spec' is dereferenced in
> nla_for_each_nested(), but it can take null value in nla_find() function,
> which will result in an error.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
>  1 file changed, 2 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
