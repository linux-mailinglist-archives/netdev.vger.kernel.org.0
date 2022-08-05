Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7166858AC8A
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 16:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbiHEOzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiHEOzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 10:55:21 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC43DF33;
        Fri,  5 Aug 2022 07:55:19 -0700 (PDT)
Received: from [10.10.132.123] (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 71C5240755C7;
        Fri,  5 Aug 2022 14:55:14 +0000 (UTC)
Message-ID: <416d3063-910d-daa9-5971-859a13f271f0@ispras.ru>
Date:   Fri, 5 Aug 2022 17:55:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] can: j1939: fix memory leak of skbs
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
References: <20220708175949.539064-1-pchelkin@ispras.ru>
 <20220729042244.GC30201@pengutronix.de>
 <18aa0617-0afe-2543-89cf-2f04c682ea88@ispras.ru>
 <20220805095515.GA10667@pengutronix.de>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
In-Reply-To: <20220805095515.GA10667@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.2022 12:55, Oleksij Rempel wrote:
> Can you please test it?

That works fine. I'm preparing a patch for the issue.
