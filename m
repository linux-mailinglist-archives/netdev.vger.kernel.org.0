Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8228492F12
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349097AbiARUOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349098AbiARUON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:14:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B824C061574;
        Tue, 18 Jan 2022 12:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51A8FB81803;
        Tue, 18 Jan 2022 20:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD28DC340E0;
        Tue, 18 Jan 2022 20:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642536851;
        bh=DlHdeXzjECbxaJwQVBy3YSulzif+klrPVSABU+KcSEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kk53RwCgXEYjKllMos8zA6LCm8NNdZuwovPImNq+h1nxopYTqt+oxEvsF9zkryLJ+
         nLMFz0DFaxV/m6KEZ0OFToVdaK9tHb95cJRddak4Q+1Ggu6qsocZyny2yyp3OT8IZc
         gtAfYUV8GnqeFp1h5YH9h/Cb0nJWhUTJMz/ZGM8pVWlzrx58egKXnqAa524r0z29lV
         FncmUT3e4dcBZNXGPJMiGKqmmyL+QzscHZNu/E+Z4yPWcOzNIWMiAK9+nSb+rckMHG
         vpKzqmqXWYllkDGM9CWHXDwb6jx1dBZpzJi/Fc0ZDEXgypOJJ1z4/MYq6wyq0c2CSO
         73ww7YEBQZuTg==
Date:   Tue, 18 Jan 2022 12:14:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     David Miller <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] nfc: llcp: fix and improvements
Message-ID: <20220118121409.6f89b651@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <9fcef93a-7afa-06ad-66e4-2cb22c6ea0ae@canonical.com>
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
        <20220116.123211.1251576778673440603.davem@davemloft.net>
        <9fcef93a-7afa-06ad-66e4-2cb22c6ea0ae@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Jan 2022 17:58:28 +0100 Krzysztof Kozlowski wrote:
> On 16/01/2022 13:32, David Miller wrote:
> > 
> > Please don't mix cleanups and bug fixes.  
> 
> The fix is the first patch, so it is easy to apply. Do you wish me to
> resend it?

Yes, please. 99% sure Dave is expecting you to do so.

FWIW the scripts I use for tag normalization and adding Links won't
work when picking one patch out of entire series so repost is best.
Thanks!
