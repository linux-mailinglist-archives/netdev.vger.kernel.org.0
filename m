Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDC45B5152
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 23:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIKVWg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Sep 2022 17:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIKVWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 17:22:34 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8553527170
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 14:22:33 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-D3LWdDnfPIus-HdmY1jgsg-1; Sun, 11 Sep 2022 17:22:27 -0400
X-MC-Unique: D3LWdDnfPIus-HdmY1jgsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 963EC802E5D;
        Sun, 11 Sep 2022 21:22:26 +0000 (UTC)
Received: from hog (unknown [10.39.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28BB12026D64;
        Sun, 11 Sep 2022 21:22:25 +0000 (UTC)
Date:   Sun, 11 Sep 2022 23:22:15 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, raeds@nvidia.com,
        tariqt@nvidia.com
Subject: Re: [PATCH main v5 2/2] macsec: add user manual description for
 extended packet number feature
Message-ID: <Yx5Rh4IfSq8V9sqh@hog>
References: <20220911092656.13986-1-ehakim@nvidia.com>
 <20220911092656.13986-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20220911092656.13986-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-09-11, 12:26:56 +0300, Emeel Hakim wrote:
> Update the user manual describing how to use extended packet number (XPN)
> feature for macsec. As part of configuring XPN, providing ssci and salt is
> required hence update user manual on  how to provide the above as part of
> the ip macsec command.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

