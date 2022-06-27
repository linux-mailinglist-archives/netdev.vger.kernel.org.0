Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACECC55C13C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240024AbiF0SDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbiF0SDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:03:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903A564FA;
        Mon, 27 Jun 2022 11:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCF4B81751;
        Mon, 27 Jun 2022 18:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAF6C3411D;
        Mon, 27 Jun 2022 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656352981;
        bh=SiYVuzJmsR0EcUFaEmT4JvsyCWMGN3J+T2tx2tthy3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J5J5zZnwFHz8UepsXkhw2qbsq6c7XmzL7CE/fSTm0hk7cuPpDZT1WzKc5sIxDFRHF
         l6G7huxhqT1vdNz8YIGQndcBTqkSs1gbJ3aBLDs3Cu59R9AfENXKlTIkX7ZRDMdUqj
         egTfWceRwScmwcPQd01oxEp1F/gtdhX02I5RjoAkizlX4N0YtsWjeFiV2pgXQo9UUi
         /Ud5yucnoIMIf+JEORc72jGEM5X1AaFaHsGE+n7QjL5arWu/UItnb9ICmo1jje1aC3
         fah4i9fEXHNqIBRnM0M9FU1OPYfzYnv/gAZasVuOlS07QzP6R6QCClg8R2gpFMx/v9
         QCMI3lLFyV8mw==
Date:   Mon, 27 Jun 2022 11:02:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "XueBing Chen" <chenxuebing@jari.cn>
Cc:     davem@davemloft.net, pabeni@redhat.com, jeroendb@google.com,
        csully@google.com, awogbemila@google.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gve: drop unexpected word 'a' in comments
Message-ID: <20220627110252.16f322bc@kernel.org>
In-Reply-To: <762564ba.c84.18199e7b56b.Coremail.chenxuebing@jari.cn>
References: <762564ba.c84.18199e7b56b.Coremail.chenxuebing@jari.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_HEX autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jun 2022 16:08:28 +0800 (GMT+08:00) XueBing Chen wrote:
> Subject: [PATCH] gve: drop unexpected word 'a' in comments
> Date: Sat, 25 Jun 2022 16:08:28 +0800 (GMT+08:00)
> X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
>  Copyright (c) 2002-2022 www.mailtech.cn
>  mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
> 
> 
> there is an unexpected word 'a' in the comments that need to be dropped

Jilin Yuan <yuanjilin@cdjrlc.com> is already sending this sort of patches,
are you working together? You patches don't follow the guidance we gave
in: https://lore.kernel.org/all/20220623092208.1abbd9dc@kernel.org/
please apply that feedback for your submissions.
