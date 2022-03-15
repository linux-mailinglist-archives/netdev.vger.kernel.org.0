Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558924DA29B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245104AbiCOSrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbiCOSrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:47:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFD545AD6;
        Tue, 15 Mar 2022 11:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1647369956;
        bh=BxC3kmRMFsoWo5jWjMIYIoKZboynjGNnbtSdqivysFQ=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=e7kx7Q8quPk8aDu6ARFPzTHt8zkgxSPGRugulj7yNPvC4NMeD7dVpRlZkyATuTPTa
         lmGN8aUeBXMLBb4ERx+xPO2xEt+g5eJWD4AeW6uvgy+3yCW1A9lQwFxGK4y96xDhyR
         2jv1i93ZWXGFK0jfORU1+UIxttrqVqcpeWiqdMzE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.131.186]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MkHQh-1nwxPp2T9N-00khpD; Tue, 15
 Mar 2022 19:45:56 +0100
Message-ID: <29f1daf3-e9f2-bbc5-f5e5-6334c040e3fa@gmx.de>
Date:   Tue, 15 Mar 2022 19:44:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: mark tulip obsolete
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org
References: <20220315184342.1064038-1-kuba@kernel.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220315184342.1064038-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:enbUpS5n2BQn5Fcs9FLWoLq+U1pA4kZq2ttlcwk4J/0j1NonOnN
 J/J2a2CLn7jN48osz8rdDwzZuEwlZcWmBcyS5mfLqAHDP4E9eGJ7rcaqkSKuKna/3GpcOHt
 eL8ChKvAXutbS5BytJwCvamG+86JLcMQB94D6CfBc1degCsx6nU/QuK8U5fRNdLLKZ4/lrR
 gRcolQuW/XF1rNzinzwVQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y87XNfF/1dk=:Ys8Ec1263Tnjt7frH4lK29
 CkbOc+DAMLQtMPgIvbhTVhSvLVt5hxl25qGUvD8G6BoD2C4AqopkCSzG5OlGRqactqiCVykyB
 JeiUWysIyAyIshLUx+bum66zHieM9KGU/DMBKFXEK+mmkdbojC6Ou0gTJWzGbxp/hqOjmt9KZ
 b1yp/pcMWkOVX8vUDNp31ueM14p9Rxp9pVDd5pGpIgdlwF0qUPQJgdAalDPHxnzccBwhYk2UD
 Sc3WEH/M4Cir9M5DAEIdPp7wuLtlVHjdAO2C9bpRjcANU+ga0O2NtncRiNUWgIGytOExQLvqP
 nCi+rcLRLo0t2jt2NmFyPUY+XnIuWGvlmOeD3wSzwr+ZxNbZfikZcFp45tatmcx5X14sliAQr
 YL4cvMmTnhz30HMCAm1a2eTDtm6M2qpBQHouHtRDkK36GS07uH6FvRjz7eLcLoc2PFftw1VwC
 mB7p1c4Q9iLZ8tuMTScrTqy2Xi2m76rOipO7GVyxhn35oiM8pCKg9EuQTeYQn64Famcym+/q4
 9geXd0cQ39lp7ijXiZ7swzWq+sxnCbLZys8DTm99evU2hpFtS9Y+ObIeDHM8kTmEltIFih89h
 T0BjIt39BG+3gLIfNl+/XaDfrw3/bVTmZssj3x2Tys2epdjmJlv25sKvOXvLUAXFIYty7kfmS
 C3haYaFvGh4Cbvb/TjXM4gNorig3LPVsDnFYbUFteJaCnlqDQPngDk6J3NfkXoULRIxpxrvZU
 WACihs4x0Aibz24BgB+AU18AgL3vUFJB3zfMofavvzsEgSWBccyN+BTyOX0s9KrZlyp+4OyeB
 2YP9jtQsPCOWRm837AMHayB5Ru9NfvnxWH40C9BRg038VJN9qWdU5qysSGviyjJh2VTlbrauQ
 3wfpR0r1N9/Z2Qy/Ej30M16ngXFY7aj6Nq1R3zSEPqPnbm3f7nv6I4J3Y9U53qEPmSIQJ5fQO
 P5ZngwVPyY2k4wAroCea5gyAVCMQF2YslmbO9T0+hR1j1EB75Khlhtlkf38H9SWzhiucJL7e2
 yhHRVIsJf0hxZT+rzp4BHjhjnDqAhPJv6fDmww4rOEDxQsM7NAMJQsbyvBGhn35+EWohHwa+/
 Vgk+4JvsPpRw4U=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 19:43, Jakub Kicinski wrote:
> It's ancient, an likely completely unused at this point.
> Let's mark it obsolete to prevent refactoring.

NAK.

This driver is needed by nearly all PA-RISC machines.

Helge


> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1397a6b039fb..9afe495a86ca 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19687,7 +19687,7 @@ F:	drivers/media/tuners/tua9001*
>  TULIP NETWORK DRIVERS
>  L:	netdev@vger.kernel.org
>  L:	linux-parisc@vger.kernel.org
> -S:	Orphan
> +S:	Orphan / Obsolete
>  F:	drivers/net/ethernet/dec/tulip/

