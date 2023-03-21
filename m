Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D9B6C275F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjCUBVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCUBVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:21:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9804C09;
        Mon, 20 Mar 2023 18:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3CAB811C6;
        Tue, 21 Mar 2023 01:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9340C433EF;
        Tue, 21 Mar 2023 01:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679361580;
        bh=cOyAMd8SLZqFSZrum3Teub3OqA39attRY9PRS9aybAc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y4dlbE+9dz2Jiw5M3l8rWpKJ4kxpj/9GVpdl7bS56zRkHrahuRTdi1cEk/5GJjBF3
         kBYr/tGS00uzPBCWd0+no/guTcLCCoYqlaep/m556OMl2AADh2w789J5XRu2334H0S
         Nk4C+OypFuW/wb/B8+Xpr0SA2zCUECVGbqbscZXncFEVb6ThEaa/xbyFEXeyJCzOlw
         JKMIRI+B2RzXE0STvqSBv4bK/ZTwQmFkaZ7j6DAQ5N1jt002krHYvfb3PuRGZEyxsh
         ozEGN1cBJip3776IR4kOg/GAQdx9CPxZSn8TygAmwWrDFVIcLANcczNr0tYyUwTG6G
         7jNkFCYi3HfXw==
Date:   Mon, 20 Mar 2023 18:19:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230320181938.1b7e8139@kernel.org>
In-Reply-To: <20230320174840.4db888eb@hermes.local>
References: <20230315223044.471002-1-kuba@kernel.org>
        <8da9b24b-966a-0334-d322-269b103f7550@gmail.com>
        <20230320170221.27896adb@kernel.org>
        <20230320174840.4db888eb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 17:48:40 -0700 Stephen Hemminger wrote:
> > On Thu, 16 Mar 2023 16:16:39 -0700 Florian Fainelli wrote: =20
> > > Did it not stand for New API?   =20
> >=20
> > I think it did. But we had extra 20 years of software development
> > experience and now agree that naming things "new" or "next" is
> > a bad idea? So let's pretend it stands for nothing. Or NAPI API ;) =20
>=20
>=20
> Maybe just a footnote like:
>   [1] Was originally referred to as New API in 2.4 Linux.

=F0=9F=91=8C=EF=B8=8F let me find out how to make a footnote in sphinx
