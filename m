Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105B44CB82D
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiCCHzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 02:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiCCHzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 02:55:15 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59CB16FDF5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 23:54:30 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9DF7C201D5;
        Thu,  3 Mar 2022 08:54:28 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tEQlNkTDKlcj; Thu,  3 Mar 2022 08:54:28 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1EB0820536;
        Thu,  3 Mar 2022 08:54:28 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 189DC80004A;
        Thu,  3 Mar 2022 08:54:28 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Thu, 3 Mar 2022 08:54:27 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 3 Mar
 2022 08:54:27 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 393103182EC9; Thu,  3 Mar 2022 08:54:27 +0100 (CET)
Date:   Thu, 3 Mar 2022 08:54:27 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Kai Lueke <kailueke@linux.microsoft.com>,
        Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
Message-ID: <20220303075427.GB3581047@gauss3.secunet.de>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
 <20220301150930.GA56710@Mem>
 <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
 <20220301161001.GV1223722@gauss3.secunet.de>
 <20220302080439.2324c5d0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <6c2d3e6b-23f8-d4a4-4701-ff9288c18a5c@linux.microsoft.com>
 <20220302213349.0ea3ad05@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220302213349.0ea3ad05@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 09:33:49PM -0800, Jakub Kicinski wrote:
> On Wed, 2 Mar 2022 19:11:06 +0100 Kai Lueke wrote:
> > > Agreed. FWIW would be great if patch #2 started flowing towards Linus'es
> > > tree separately if the discussion on #1 is taking longer.  
> > 
> > to preserve the initial goal of helping to uncover id 0 usage I think it
> > would be best to have the revert be accompanied by a patch that instead
> > creates a kernel log warning (or whatever).
> 
> extack would be best, but that would mean a little bit of plumbing 
> so more likely net-next material. Which would have to come after.

We need something that a user directly sees that the configuration is
invalid. That the xfrm interface acts as a blackhole whith IF_ID 0
is one thing (revert #1).

The other thing is that IF_ID 0 for a policy/state internally means
that these are not assigned to a xfrm interface. So a policy/state
with IF_ID 0 will match flows that are not targeted to the xfrm
interface. This means that confidential stuff could be sent to the
wrong peer (revert #2).

> 
> > Since I never did that I suggest to not wait for me.
> > Also, feel free to do the revert yourself with a different commit
> > message if mine didn't capture the things appropriately.
> 
> TBH I'm not 100% clear on the nature of the regression. Does Cilium
> update the configuration later to make if_id be non-zero? Or the broken 
> interface is not used but not being able to create it fails the whole
> configuration?

As far I unerstood Pauls mail, only 68ac0f3810e7 ("xfrm: state and policy
should fail if XFRMA_IF_ID 0") caused issues in Cilium.

So maybe just revert that one and document that IF_ID 0 on a policy/state
is the same as configuring the policy/state without IF_ID.
