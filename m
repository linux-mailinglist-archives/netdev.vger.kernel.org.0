Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4174F578D49
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiGRWEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiGRWE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:04:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9AE1F2D6;
        Mon, 18 Jul 2022 15:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 778DBB817B5;
        Mon, 18 Jul 2022 22:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E7DC341C0;
        Mon, 18 Jul 2022 22:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658181860;
        bh=3JxZkLM8MBszfDbDjwosYrF471wfmGyjogJnExYKUPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BSlcJtetWKT66UYJ5KpIsH1zskh3T2ZqU/URAT5Y8TZeNrDkyU4XdYFBS1UCq8HGs
         OeAcEtyYH5QPq1S0Yf81A5dfERgEQxdiY1nFXXqysSevgo4VJ10WCEzxjCSTsywggx
         5o3XEpBmhlD+Mj4w7jqRwz28mrK0Ev4Pvv7VC/qnVVpXS6vgAgZnf3vmjMzM//0TM+
         m2PNihIHQjQ8iDbkBmz1rc3GpaRWbkpAqP8iOcdqqB4t+W5qDj3Ykk/sudVMnTAfSN
         MIStUtpzJ2s7xfcOgw526ZqsCKTTUvFKUQGKMYkCj01RTmOKRLDqptGyKlWg1k0DIr
         kQpGkmvYq8x6g==
Date:   Mon, 18 Jul 2022 15:04:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Dave Airlie <airlied@gmail.com>, torvalds@linux-foundation.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        mcgrof@kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.sf.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, linux-block@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines.
Message-ID: <20220718150414.1767bbd8@kernel.org>
In-Reply-To: <97e5afd3-77a3-2227-0fbf-da2f9a41520f@leemhuis.info>
References: <20220718072144.2699487-1-airlied@gmail.com>
        <97e5afd3-77a3-2227-0fbf-da2f9a41520f@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 11:33:11 +0200 Thorsten Leemhuis wrote:
> > If the hardware isn't
> > +  enabled by default or under development,  
> 
> Wondering if it might be better to drop the "or under development", as
> the "enabled by default" is the main part afaics. Maybe something like
> "If support for the hardware is normally inactive (e.g. has to be
> enabled manually by a kernel parameter)" would be better anyway.

It's a tricky one, I'd say something like you can break the FW ABI
"until HW becomes available for public consumption" or such.
I'm guessing what we're after is letting people break the compatibility
in early stages of the product development cycles. Pre-silicon and
bring up, but not after there are products on the market?
