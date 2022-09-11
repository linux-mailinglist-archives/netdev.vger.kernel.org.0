Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75F55B5150
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIKVVL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Sep 2022 17:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIKVVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 17:21:10 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65B26AFA
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 14:21:09 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-VlWnTHXrMEeWFxsBIb7eDg-1; Sun, 11 Sep 2022 17:21:05 -0400
X-MC-Unique: VlWnTHXrMEeWFxsBIb7eDg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6C983C025AC;
        Sun, 11 Sep 2022 21:21:04 +0000 (UTC)
Received: from hog (unknown [10.39.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AFE5492C3B;
        Sun, 11 Sep 2022 21:21:02 +0000 (UTC)
Date:   Sun, 11 Sep 2022 23:20:53 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, raeds@nvidia.com,
        tariqt@nvidia.com
Subject: Re: [PATCH main v5 1/2] macsec: add Extended Packet Number support
Message-ID: <Yx5RNSTJ4lcndzcO@hog>
References: <20220911092656.13986-1-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20220911092656.13986-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

2022-09-11, 12:26:55 +0300, Emeel Hakim wrote:
> This patch adds support for extended packet number (XPN).
> XPN can be configured by passing 'cipher gcm-aes-xpn-128' as part of
> the ip link add command using macsec type.
> In addition, using 'xpn' keyword instead of the 'pn', passing a 12
> bytes salt using the 'salt' keyword and passing short secure channel
> id (ssci) using the 'ssci' keyword as part of the ip macsec command
> is required (see example).
> 
> e.g:
> 
> create a MACsec device on link eth0 with enabled xpn
>   # ip link add link eth0 macsec0 type macsec port 11
> 	encrypt on cipher gcm-aes-xpn-128
> 
> configure a secure association on the device
>   # ip macsec add macsec0 tx sa 0 xpn 1024 on ssci 5
> 	salt 838383838383838383838383
> 	key 01 81818181818181818181818181818181
> 
> configure a secure association on the device with ssci = 5
>   # ip macsec add macsec0 tx sa 0 xpn 1024 on ssci 5
> 	salt 838383838383838383838383
> 	key 01 82828282828282828282828282828282
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Looks good now, thanks.
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina

