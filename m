Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAA7645D2D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiLGPC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiLGPCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:02:37 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB19062EA5
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:02:02 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-qwpBp8X0PsiByp9abe6HCw-1; Wed, 07 Dec 2022 10:01:56 -0500
X-MC-Unique: qwpBp8X0PsiByp9abe6HCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7B9C8027EC;
        Wed,  7 Dec 2022 15:01:55 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F396BFD48;
        Wed,  7 Dec 2022 15:01:53 +0000 (UTC)
Date:   Wed, 7 Dec 2022 16:00:51 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, atenart@kernel.org,
        jiri@resnulli.us
Subject: Re: [PATCH net] macsec: add missing attribute validation for offload
Message-ID: <Y5Cqo5e0d7a3buyu@hog>
References: <20221207101618.989-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221207101618.989-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-12-07, 12:16:18 +0200, ehakim@nvidia.com wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Add missing attribute validation for IFLA_MACSEC_OFFLOAD
> to the netlink policy.
> 
> Fixes: 791bb3fcafce ("net: macsec: add support for specifying offload upon link creation")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

