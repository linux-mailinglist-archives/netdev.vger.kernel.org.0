Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6C94C8FBA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiCAQKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbiCAQKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:10:46 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC38B1409A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:10:04 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9258E201CC;
        Tue,  1 Mar 2022 17:10:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Br5vVx6hSwJC; Tue,  1 Mar 2022 17:10:02 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 21BE4200A2;
        Tue,  1 Mar 2022 17:10:02 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 1BFB880004A;
        Tue,  1 Mar 2022 17:10:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 1 Mar 2022 17:10:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 1 Mar
 2022 17:10:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1C79431840BE; Tue,  1 Mar 2022 17:10:01 +0100 (CET)
Date:   Tue, 1 Mar 2022 17:10:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Kai =?iso-8859-1?Q?L=FCke?= <kailueke@linux.microsoft.com>
CC:     Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
Message-ID: <20220301161001.GV1223722@gauss3.secunet.de>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
 <20220301150930.GA56710@Mem>
 <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
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

On Tue, Mar 01, 2022 at 04:48:38PM +0100, Kai Lüke wrote:
> > I agree with Eyal here.  As far as Cilium is concerned, this is not
> > causing any regression.  Only the second commit, 68ac0f3810e7 ("xfrm:
> > state and policy should fail if XFRMA_IF_ID 0") causes issues in a
> > previously-working setup in Cilium.  We don't use xfrm interfaces.
> >
> I see this as a very generic question of changing userspace behavior or
> not, regardless if we know how many users are affected, and from what I
> know there are similar cases in the kernel where the response was that
> breaking userspace is a no go - even if the intention was to be helpful
> by having early errors.

In general I agree that the userspace ABI has to be stable, but
this never worked. We changed the behaviour from silently broken to
notify userspace about a misconfiguration.

It is the question what is more annoying for the users. A bug that
we can never fix, or changing a broken behaviour to something that
tells you at least why it is not working.

In such a case we should gauge what's the better solution. Here
I tend to keep it as it is.
