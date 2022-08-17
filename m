Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E73596F0A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiHQNCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239414AbiHQNCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:02:15 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FBE50051
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 06:02:13 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-NZQ4NCOoN3WASB5cMubqUA-1; Wed, 17 Aug 2022 09:02:07 -0400
X-MC-Unique: NZQ4NCOoN3WASB5cMubqUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 870968039B9;
        Wed, 17 Aug 2022 13:02:06 +0000 (UTC)
Received: from hog (unknown [10.39.193.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 836AAC15BB3;
        Wed, 17 Aug 2022 13:02:04 +0000 (UTC)
Date:   Wed, 17 Aug 2022 15:01:56 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     edumazet@google.com, mayflowerera@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next 1/1] net: macsec: Expose MACSEC_SALT_LEN
 definition to user space
Message-ID: <YvzmxKnQ7pMg0KxF@hog>
References: <20220817105815.8712-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817105815.8712-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-08-17, 13:58:15 +0300, Emeel Hakim wrote:
> Expose MACSEC_SALT_LEN definition to user space to be
> used in various user space applications such as iproute.
> Iprotue will use this as part of adding macsec extended

nit: spelling of "Iproute"

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

