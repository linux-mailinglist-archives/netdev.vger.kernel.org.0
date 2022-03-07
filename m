Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA64CF377
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 09:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbiCGIXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 03:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiCGIXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 03:23:45 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D10833371
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 00:22:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 04149201A0;
        Mon,  7 Mar 2022 09:22:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lxvvUizgNuUV; Mon,  7 Mar 2022 09:22:46 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4EB6C2006F;
        Mon,  7 Mar 2022 09:22:46 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 48B7080004A;
        Mon,  7 Mar 2022 09:22:46 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 7 Mar 2022 09:22:46 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 09:22:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 750253180BF5; Mon,  7 Mar 2022 09:22:45 +0100 (CET)
Date:   Mon, 7 Mar 2022 09:22:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <kailueke@linux.microsoft.com>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH] Revert "xfrm: state and policy should fail if
 XFRMA_IF_ID 0"
Message-ID: <20220307082245.GA1791239@gauss3.secunet.de>
References: <20220303145510.324-1-kailueke@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220303145510.324-1-kailueke@linux.microsoft.com>
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

On Thu, Mar 03, 2022 at 03:55:10PM +0100, kailueke@linux.microsoft.com wrote:
> From: Kai Lueke <kailueke@linux.microsoft.com>
> 
> This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because ID
> 0 was meant to be used for configuring the policy/state without
> matching for a specific interface (e.g., Cilium is affected, see
> https://github.com/cilium/cilium/pull/18789 and
> https://github.com/cilium/cilium/pull/19019).
> 
> Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>

Applied, thanks Kai!

