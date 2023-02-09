Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D68690B41
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBIOEQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 9 Feb 2023 09:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjBIOEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:04:15 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC612D6F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 06:04:14 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-9K7WMDo-NoGzWZCcbQKShg-1; Thu, 09 Feb 2023 09:03:57 -0500
X-MC-Unique: 9K7WMDo-NoGzWZCcbQKShg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E886D1C04B6B;
        Thu,  9 Feb 2023 14:03:56 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDDE9140EBF6;
        Thu,  9 Feb 2023 14:03:54 +0000 (UTC)
Date:   Thu, 9 Feb 2023 15:02:11 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Hyunwoo Kim <v4bel@theori.io>, steffen.klassert@secunet.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, imv4bel@gmail.com, netdev@vger.kernel.org
Subject: Re: [v2 PATCH] xfrm: Zero padding when dumping algos and encap
Message-ID: <Y+T84+VIBytBSLrJ@hog>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
 <20230208085434.GA2933@ubuntu>
 <Y+N4Q2B01iRfXlQu@gondor.apana.org.au>
 <Y+RH4Fv8yj0g535y@gondor.apana.org.au>
MIME-Version: 1.0
In-Reply-To: <Y+RH4Fv8yj0g535y@gondor.apana.org.au>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

2023-02-09, 09:09:52 +0800, Herbert Xu wrote:
> v2 fixes the mistaken type of XFRMA_ALG_COMP for x->encap.
> 
> ---8<---
> When copying data to user-space we should ensure that only valid
> data is copied over.  Padding in structures may be filled with
> random (possibly sensitve) data and should never be given directly
> to user-space.
> 
> This patch fixes the copying of xfrm algorithms and the encap
> template in xfrm_user so that padding is zeroed.
> 
> Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
> Reported-by: Hyunwoo Kim <v4bel@theori.io>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks Herbert.
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

