Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114274F35A9
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiDEKxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345814AbiDEJoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:44:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A0C55B9
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 02:29:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1288920569;
        Tue,  5 Apr 2022 11:29:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P0j5NHflAAp2; Tue,  5 Apr 2022 11:29:28 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8F90E20527;
        Tue,  5 Apr 2022 11:29:28 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8941C80004A;
        Tue,  5 Apr 2022 11:29:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 5 Apr 2022 11:29:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 11:29:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AC1133182E07; Tue,  5 Apr 2022 11:29:27 +0200 (CEST)
Date:   Tue, 5 Apr 2022 11:29:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <oliver.sang@intel.com>,
        <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net] xfrm: Pass flowi_oif or l3mdev as oif to
 xfrm_dst_lookup
Message-ID: <20220405092927.GA2517843@gauss3.secunet.de>
References: <20220401185837.40626-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220401185837.40626-1-dsahern@kernel.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Fri, Apr 01, 2022 at 12:58:37PM -0600, David Ahern wrote:
> The commit referenced in the Fixes tag no longer changes the
> flow oif to the l3mdev ifindex. A xfrm use case was expecting
> the flowi_oif to be the VRF if relevant and the change broke
> that test. Update xfrm_bundle_create to pass oif if set and any
> potential flowi_l3mdev if oif is not set.
> 
> Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied to the ipsec tree, thanks David!
