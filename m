Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475824644E0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 03:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245544AbhLACbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 21:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbhLACbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 21:31:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CF5C061574;
        Tue, 30 Nov 2021 18:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73EEACE1D62;
        Wed,  1 Dec 2021 02:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65133C53FCB;
        Wed,  1 Dec 2021 02:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638325663;
        bh=InhH7V0QxXh94iwiWcagV90SEoJ3BYWf2hm34dKpvYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XZkZ3RHQNOHB05pOK+PWwGechLeeqsrc6J8zivtQQUXbx7TmvtvR/0Ov/CPNRwNP5
         wkxPZ058nj1Fw3D2hCuioJuHvAvi/DMN1IeQx1Wgd1dJ8xdOaazZWxmcLWMNE7qKKQ
         1S/sqW2Hfu9u2K63nfCZN8RTgOBL4kYmBLlLcRNArOhIP96lJ9bXIId2OGDxTtxEw/
         RhjNWSFHIV0XTx8/3ze0R7bGcBALI5l0lyyjpqzYO5Gr9LAvbWTUoBlgqpPsvesDdS
         z+cknIl6sqUwxCrk3EdssQKuv4glPHDlgDfZDQ6K+jGPDW8lmsN2Cx+bIH5mHKqmTF
         6B0e2g11S3KCg==
Date:   Tue, 30 Nov 2021 18:27:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 01/15] skbuff: introduce skb_pull_data
Message-ID: <20211130182742.7537e212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABBYNZJGpswn03StZb97XQOUu5rj2_GGkj-UdZWdQOwuWwNVXQ@mail.gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
        <20211201000215.1134831-2-luiz.dentz@gmail.com>
        <20211130171105.64d6cf36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CABBYNZJGpswn03StZb97XQOUu5rj2_GGkj-UdZWdQOwuWwNVXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 18:16:02 -0800 Luiz Augusto von Dentz wrote:
> > It doesn't take a data pointer, so not really analogous to
> > skb_put_data() and friends which come to mind. But I have
> > no better naming suggestions. You will need to respin, tho,
> > if you want us to apply these directly, the patches as posted
> > don't apply to either netdev tree.  
> 
> I cross posted it to net-dev just in case you guys had some strong
> opinions on introducing such a function,

Someone else still may, I don't :)

> it was in fact suggested by Dan but I also didn't find a better name
> so I went with it, if you guys prefer we can merge it in
> bluetooth-next first as usual.

Going via bluetooth-next sounds good!
