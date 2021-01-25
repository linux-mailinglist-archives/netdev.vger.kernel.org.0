Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF893026A7
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbhAYPC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 10:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbhAYO6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:58:33 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6A6C06174A;
        Mon, 25 Jan 2021 06:57:52 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l43JE-00BS7e-SI; Mon, 25 Jan 2021 15:57:41 +0100
Message-ID: <86b59e50756f63db9734d9a786271956d26b63ee.camel@sipsolutions.net>
Subject: Re: net: tso: add UDP segmentation support: adds regression for
 ax200 upload
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        Rainer Suhm <automat@posteo.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Date:   Mon, 25 Jan 2021 15:57:39 +0100
In-Reply-To: <CANn89iLZ9Y0fMk8X1a4=J7Xf2H=M0oLK_SekOLZypN+2-8a0yw@mail.gmail.com> (sfid-20210119_110301_556335_ED40BD27)
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
         <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
         <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
         <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
         <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
         <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
         <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
         <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
         <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
         <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
         <CANn89iJBO13s9fOVRnDyfj5HXt9wjnRpbh2_f5SuyNkNAfjzJQ@mail.gmail.com>
         <CANn89iJTCDof6ypxCkiGaPo+y0Bngg0NX5cLPWisTEZaFo1BQw@mail.gmail.com>
         <CANn89iJWG2n1s3j7EdpwkQQv-9dOY02V+FGYHAWguO4JiqWuJA@mail.gmail.com>
         <d75b2c43a416d4bb84185aab4005d42e49962e36.camel@sipsolutions.net>
         <CANn89iLZ9Y0fMk8X1a4=J7Xf2H=M0oLK_SekOLZypN+2-8a0yw@mail.gmail.com>
         (sfid-20210119_110301_556335_ED40BD27)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Tue, 2021-01-19 at 11:02 +0100, Eric Dumazet wrote:
> 
> > This does fix the problems reported on iwlwifi, were you planning to
> > submit it as a proper patch?
> 
> Sure, I will do, thanks !

Did you do that and I missed it? Or would you prefer we did?

Thanks,
Johannes

