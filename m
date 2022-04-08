Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5054F99B2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbiDHPol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiDHPok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD12F83005;
        Fri,  8 Apr 2022 08:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 307846201B;
        Fri,  8 Apr 2022 15:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA1DC385A1;
        Fri,  8 Apr 2022 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649432553;
        bh=s1dk+PG922eEPvuS1m9W/dJr95X0ai1l0ApPhrkX+3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tbyfbz1oeXMpnv1/dhVsJn/u+z2iWryVor30Rpl/Da08h/Oso9wnShLBxMQj2yOGG
         Dhh7XsMFfQpufv6joYyFXru8mVE2/7nWEOhiulCp52VbarDopgQPZC+W+PTvLxTwlL
         hImN/Mb30aK1FWsDmoSDtPpHLSQmYXeHcBkgOjw4=
Date:   Fri, 8 Apr 2022 17:42:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 0/3] SOF_TIMESTAMPING_OPT_ID backport to 4.14 and
 4.19
Message-ID: <YlBX5lhYHIXE0oBK@kroah.com>
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com>
 <20220408152929.4zd2mclusdpazclv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408152929.4zd2mclusdpazclv@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 03:29:30PM +0000, Vladimir Oltean wrote:
> Hello Greg, Sasha,
> 
> On Wed, Apr 06, 2022 at 10:29:53PM +0300, Vladimir Oltean wrote:
> > As discussed with Willem here:
> > https://lore.kernel.org/netdev/CA+FuTSdQ57O6RWj_Lenmu_Vd3NEX9xMzMYkB0C3rKMzGgcPc6A@mail.gmail.com/T/
> > 
> > the kernel silently doesn't act upon the SOF_TIMESTAMPING_OPT_ID socket
> > option in several cases on older kernels, yet user space has no way to
> > find out about this, practically resulting in broken functionality.
> > 
> > This patch set backports the support towards linux-4.14.y and linux-4.19.y,
> > which fixes the issue described above by simply making the kernel act
> > upon SOF_TIMESTAMPING_OPT_ID as expected.
> > 
> > Testing was done with the most recent (not the vintage-correct one)
> > kselftest script at:
> > tools/testing/selftests/networking/timestamping/txtimestamp.sh
> > with the message "OK. All tests passed".
> 
> Could you please pick up these backports for "stable"? Thanks.

You sent this 2 days ago!

Please relax :)
