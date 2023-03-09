Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E900D6B1934
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCICak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCICai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3626C9E679;
        Wed,  8 Mar 2023 18:30:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8280619E4;
        Thu,  9 Mar 2023 02:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBDEC433EF;
        Thu,  9 Mar 2023 02:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678329037;
        bh=PqX5r+wQ2snvZrC6N2v+9hO1Mc7qlc99RVrg1ClhoIc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PAhUGmOMciBrSEd8tmKqkG9z+KZnhCZpa45x2vzou0kJl2Zb6hvmen1iBIo2E4c0L
         vlNJ6E4s5woyAoLOtiq4M0/XTArGr7XSpoZWIyRi3TjQU+qSVCMkXSTfSN2S0Tzzl+
         YzKPXk7iZrLhyrc4gzB60iB235maG4kdKzJpA4PPCjq5nOrArLPkgZlBJTk/umAwtT
         C2j8czTTzuGpHaO8Jcn0Xp9MfxYopRe7JrciHHc4tpc7mAnAM76LjY75ry6/OQ5dwX
         fTzII5jSMVAugTDNdHrkiwE1La9Oz3uzR23fohVfrIq5Br3aur2ttVsAbTMR1kqg1j
         1LqsjgYyvomhg==
Date:   Wed, 8 Mar 2023 18:30:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Subject: Re: [PATCH] nfc: pn533: initialize struct pn533_out_arg properly
Message-ID: <20230308183035.0fb2febd@kernel.org>
In-Reply-To: <ZAdcGkqnfRDwJq5y@corigine.com>
References: <20230306214838.237801-1-pchelkin@ispras.ru>
        <ZAdcGkqnfRDwJq5y@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Mar 2023 16:45:30 +0100 Simon Horman wrote:
> nit: This doesn't follow reverse xmas tree ordering - longest to shortest line.
>      It's probably not worth respinning, but I expect the preferred
>      approach is (*completely untested!*)
> 
> 	...
> 	struct pn533_out_arg arg;
> 	...
> 
> 	arg.phy = phy;

Let's do it this way.

And please make sure that the patch is based on top of the netdev/net
tree from git.kernel.org, looks like this version doesn't apply cleanly.
