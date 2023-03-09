Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1742E6B2AAF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCIQ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCIQ0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:26:36 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00192C65E;
        Thu,  9 Mar 2023 08:18:14 -0800 (PST)
Received: from fpc (unknown [10.10.165.5])
        by mail.ispras.ru (Postfix) with ESMTPSA id 588BE4077AE7;
        Thu,  9 Mar 2023 16:10:30 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 588BE4077AE7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678378230;
        bh=7lqJ9RnfZJMlCAtU5e6bKje5JAM46QpC7OJvhT+0+Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PyOnG6n2v+hmfKQ+cXfCZXCNDJqY0zo8Ib8yEKJEk48MoxVDxFlPip65YuU/sYgD7
         3NgxENzViZd9VsibxWPYpDppqRVE0OCB6t3Ktz6HwW0qi8iaUI00omzsut1vYrhPBD
         sHMSUjeMHDWDC2XMkfD08JpeZ5LTkYnNKtlb2CS0=
Date:   Thu, 9 Mar 2023 19:10:25 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Subject: Re: [PATCH] nfc: pn533: initialize struct pn533_out_arg properly
Message-ID: <20230309161025.bfezdhoazzirykbr@fpc>
References: <20230306214838.237801-1-pchelkin@ispras.ru>
 <ZAdcGkqnfRDwJq5y@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAdcGkqnfRDwJq5y@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 04:45:30PM +0100, Simon Horman wrote:
> 
> nit: This doesn't follow reverse xmas tree ordering - longest to shortest line.
>      It's probably not worth respinning, but I expect the preferred
>      approach is (*completely untested!*)
> 
> 	...
> 	struct pn533_out_arg arg;
> 	...
> 
> 	arg.phy = phy;
> 

That is much prettier, thanks for advice!

BTW, is reverse xmas tree ordering considered to be a general
recommendation for all new kernel patches?
