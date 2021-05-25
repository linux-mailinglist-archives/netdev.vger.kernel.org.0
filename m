Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA31038FF02
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhEYK0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:26:38 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:45968 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhEYK0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:26:25 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id F3031800057;
        Tue, 25 May 2021 12:24:52 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 12:24:52 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 25 May
 2021 12:24:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 437D93180299; Tue, 25 May 2021 12:24:52 +0200 (CEST)
Date:   Tue, 25 May 2021 12:24:52 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: add state hashtable keyed by seq
Message-ID: <20210525102452.GX40979@gauss3.secunet.de>
References: <d5f097821cddd17ddcba75f5153f034322c9fc6b.1619194963.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d5f097821cddd17ddcba75f5153f034322c9fc6b.1619194963.git.sd@queasysnail.net>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 09:47:12PM +0200, Sabrina Dubroca wrote:
> When creating new states with seq set in xfrm_usersa_info, we walk
> through all the states already installed in that netns to find a
> matching ACQUIRE state (__xfrm_find_acq_byseq, called from
> xfrm_state_add). This causes severe slowdowns on systems with a large
> number of states.
> 
> This patch introduces a hashtable using x->km.seq as key, so that the
> corresponding state can be found in a reasonable time.
> 
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Now applied to ipsec-next, thanks a lot Sabrina!
