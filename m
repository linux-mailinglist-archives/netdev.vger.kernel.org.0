Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A148C6BC917
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCPI1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCPI1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:27:44 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F3FB5FFA;
        Thu, 16 Mar 2023 01:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=MX9PWOpl+gczMtq6Tm3f+M+4h8XUnDLXB2g0cF3zAzw=;
  b=ltiDjQzBUYZCsQcR73I8iQnd1u36LMOBnjeOFe36EYS3w9Qp8tyh5iw2
   NoVLBuUhT0EP3xegaN6w3qzRRW2j8D33kIdqoS6vrs1VGO433CkzP+B0q
   dzzH7d1FDsdm3X2LZo+K4soiDhTS1F3nTmZPX18NRIoIUTVXlnDtugvL0
   U=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.98,265,1673910000"; 
   d="scan'208";a="50339159"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 09:27:13 +0100
Date:   Thu, 16 Mar 2023 09:27:13 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
cc:     Dan Carpenter <error27@gmail.com>, outreachy@lists.linux.dev,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: qlge: Fix indentation in conditional
 statement
In-Reply-To: <20230316081428.GA47053@sumitra.com>
Message-ID: <c6cb3428-a785-195b-ffae-d715f3aacee7@inria.fr>
References: <20230314121152.GA38979@sumitra.com> <6e12c373-2bfd-48d8-b77d-17f710c094f7@kili.mountain> <20230316081428.GA47053@sumitra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 16 Mar 2023, Sumitra Sharma wrote:

> On Wed, Mar 15, 2023 at 10:47:21AM +0300, Dan Carpenter wrote:
> > On Tue, Mar 14, 2023 at 05:11:52AM -0700, Sumitra Sharma wrote:
> > > Add tabs/spaces in conditional statements in to fix the
> > > indentation.
> > >
> > > Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
> > >
> > > ---
> > > v2: Fix indentation in conditional statement, noted by Dan Carpenter
> > >  <error27@gmail.com>
> > > v3: Apply changes to fresh git tree
> > >
> >
> > Thanks!
> >
> > Reviewed-by: Dan Carpenter <error27@gmail.com>
> >
>
> Hi dan,
>
> Will this be considered as my first accepted patch? :)


I think it is accepted only when Greg takes it into his tree and you can
have a link for it.

julia

>
> Regards,
>
> Sumitra
> > regards,
> > dan carpenter
> >
>
>
