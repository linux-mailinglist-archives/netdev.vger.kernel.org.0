Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC13638473
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKYH1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiKYH1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:27:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F4C2E684;
        Thu, 24 Nov 2022 23:27:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0341562240;
        Fri, 25 Nov 2022 07:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98563C433D6;
        Fri, 25 Nov 2022 07:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669361237;
        bh=U4/CSoOdPttEt+l3NRZohZvQ9h4E1gQroKu0ErXJWOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSkUVLU+5ltS7hVM8bfMKjVA/f5d2g6l6DBGD8TqT0Z4Wwwsx07MYXwjWjhdlq2NM
         DtvESNkdkNab0fqAD8WcZTAsM70omA+MEPaZK5LjotSBcnN7qkUge7D6a2QFWQkGet
         Eo62Pl5LPBoIEwPtuL2o/uXvtbLbINqC/z6nnguw=
Date:   Fri, 25 Nov 2022 08:27:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <Y4BuUU5yMI6PqCbb@kroah.com>
References: <20221123084557.945845710@linuxfoundation.org>
 <CA+G9fYvKfbJHcMZtybf_0Ru3+6fKPg9HwWTOhdCLrOBXMaeG1A@mail.gmail.com>
 <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvgaNKbr_EhWsh9hjnzCeVXGJoXX4to72ytdvZi8W0svA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 09:17:36PM +0530, Naresh Kamboju wrote:
> On Wed, 23 Nov 2022 at 19:30, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Wed, 23 Nov 2022 at 14:50, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.156 release.
> > > There are 149 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > With stable rc 5.10.156-rc1 Raspberry Pi 4 Model B failed to boot due to
> > following warnings / errors [1]. The NFS mount failed and failed to boot.
> >
> > I have to bisect this problem.
> 
> Daniel bisected this reported problem and found the first bad commit,
> 
> YueHaibing <yuehaibing@huawei.com>
>     net: broadcom: Fix BCMGENET Kconfig

But that is in 5.10.155, 5.15.79, 6.0.9, and 6.1-rc5.  It is not new to
this -rc release.

What config options are being set because of this that cause the
problem?  Should it just be reverted for 5.10.y, and not the other
branches?  Or for everywhere including Linus's tree?

thanks,

greg k-h
