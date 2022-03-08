Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81984D109D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 08:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiCHHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 02:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiCHHBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 02:01:24 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1414F25C46
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 23:00:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0CDB8204E5
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:00:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UUhBpN7CT77c for <netdev@vger.kernel.org>;
        Tue,  8 Mar 2022 08:00:26 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A14A1205CF
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:00:22 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 9BE6B80004A
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:00:22 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 8 Mar 2022 08:00:22 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 08:00:22 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AD7A43182E92; Tue,  8 Mar 2022 08:00:21 +0100 (CET)
Date:   Tue, 8 Mar 2022 08:00:21 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec 0/3] Fixes for the ipsec tree
Message-ID: <20220308070021.GC1791239@gauss3.secunet.de>
References: <20220307121141.1921944-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220307121141.1921944-1-steffen.klassert@secunet.com>
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

On Mon, Mar 07, 2022 at 01:11:38PM +0100, Steffen Klassert wrote:
> I plan to apply the following fixes to the ipsec tree:
> 
> 1) Fix possible buffer overflow in ESP output transformation.
> 
> 2) Fix BEET mode for ESP inter address family tunneling on GSO.
> 
> 3) Fix ESP GSO on inter address family tunnels.

This is now applied to thwe ipsec tree.
