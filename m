Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3662B50EFAF
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 06:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbiDZEU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 00:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiDZEUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 00:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D93E2E08E;
        Mon, 25 Apr 2022 21:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19D56608C3;
        Tue, 26 Apr 2022 04:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141D2C385A4;
        Tue, 26 Apr 2022 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650946668;
        bh=TuixHq3qt953bpbIPmz0Qo3+44v5gXGeaxVhFfbNx3k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XgoSWHrJL5WfoSsvNpJWPEDWzTLcJ1BFIRadiepELJ4ajxJ4yE/LWDP9rOhD07l6+
         1N92N9BYdD4S9cMsivFSegPO4lZvcBAQGtKoMgC/RVKTTArAdPagQtkagKTEQ+I1qE
         uhA5EzyFZOuXgvgmsr9diIcmfiWke1tUgpQ9UyG0Y0JCmR6ZO0/aPJTaZrewPt9DRJ
         rx2rbCxJyZyQlsYtWtnObjFM9oq0t0q6qXFGvJ5nszKOofwAfLyisPa5KYEdcAeyd5
         mY/uthDH15hlBJMEkvLgeyLoAhLtI0FQbJHGxK+XK8UK+phePtZiAhxcLM6appUAex
         PSTA0kM+U0Skg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS \(WIRELESS\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH v22 1/2] wireless: Initial driver submission for pureLiFi STA devices
References: <20220224182042.132466-3-srini.raju@purelifi.com>
        <165089199642.17454.12727074837478904084.kvalo@kernel.org>
        <CWLP265MB32173F6188304F6B2CB90C79E0F89@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
Date:   Tue, 26 Apr 2022 07:17:43 +0300
In-Reply-To: <CWLP265MB32173F6188304F6B2CB90C79E0F89@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
        (Srinivasan Raju's message of "Mon, 25 Apr 2022 19:11:34 +0000")
Message-ID: <87h76g1nrs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

>> Unless I don't get any comments I'm planning to merge this on Wednesday.
>
> Thanks Kalle , I do not have any comments.

Please don't use HTML, our lists drop all HTML mail.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
