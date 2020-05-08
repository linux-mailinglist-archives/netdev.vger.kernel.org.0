Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809D01CA64B
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgEHImJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 04:42:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46252 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgEHImI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 04:42:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5E30D201E4;
        Fri,  8 May 2020 10:42:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Okqu4Pui0qEm; Fri,  8 May 2020 10:42:05 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DEB1A201CC;
        Fri,  8 May 2020 10:42:05 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 8 May 2020 10:42:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 8 May 2020
 10:42:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D8BA43180197;
 Fri,  8 May 2020 10:42:04 +0200 (CEST)
Date:   Fri, 8 May 2020 10:42:04 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next v2 0/7] xfrm: remove three more indirect calls
 from packet path
Message-ID: <20200508084204.GE13121@gauss3.secunet.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:06:02AM +0200, Florian Westphal wrote:
> v2: rebase on top of ipsec-next, no other changes.
> 
> This patch series removes three more indirect calls from the state_afinfo
> struct.
> 
> These are:
> - extract_input (no dependencies on other modules)
> - output_finish (same)
> - extract_output (has dependency on ipv6 module, but
>   that is only needed for pmtu detection, so the indirect
>   call cost is not required for each packet).
> 
> Functions get moved to net/xfrm and the indirections are removed.
> pmtu detection will be handled via ipv6_stubs.
> 
> Florian Westphal (7):
>       xfrm: avoid extract_output indirection for ipv4
>       xfrm: state: remove extract_input indirection from xfrm_state_afinfo
>       xfrm: move xfrm4_extract_header to common helper
>       xfrm: expose local_rxpmtu via ipv6_stubs
>       xfrm: place xfrm6_local_dontfrag in xfrm.h
>       xfrm: remove extract_output indirection from xfrm_state_afinfo
>       xfrm: remove output_finish indirection from xfrm_state_afinfo

Series applied, thanks Florian!
