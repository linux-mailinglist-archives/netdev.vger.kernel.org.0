Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD7D666DED
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbjALJS3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Jan 2023 04:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbjALJRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:17:43 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA1C50F4A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:10:41 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-wadmZE8eNKSgOpRYsjuSOw-1; Thu, 12 Jan 2023 04:10:22 -0500
X-MC-Unique: wadmZE8eNKSgOpRYsjuSOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6C798030D2;
        Thu, 12 Jan 2023 09:10:21 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 593B3C15BA0;
        Thu, 12 Jan 2023 09:10:20 +0000 (UTC)
Date:   Thu, 12 Jan 2023 10:08:55 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        atenart@kernel.org
Subject: Re: [PATCH net-next v9 0/2] Add support to offload macsec using
 netlink update
Message-ID: <Y7/OJ0Hf+vS3rwcv@hog>
References: <20230111150210.8246-1-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230111150210.8246-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-11, 17:02:08 +0200, ehakim@nvidia.com wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> This series adds support for offloading macsec as part of the netlink
> update routine, command example:
> ip link set link eth2 macsec0 type macsec offload mac
> 
> The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
> the second patch of dumping this attribute as part of the macsec
> dump.
> 
> Emeel Hakim (2):
>   macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
>   macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
> 
>  drivers/net/macsec.c | 126 ++++++++++++++++++++++++-------------------
>  1 file changed, 70 insertions(+), 56 deletions(-)

Series:
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

Thanks Emeel.

-- 
Sabrina

