Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03D54C2798
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiBXJEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 04:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiBXJEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 04:04:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398601A58CC;
        Thu, 24 Feb 2022 01:04:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCFDA60A2B;
        Thu, 24 Feb 2022 09:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F3EC340E9;
        Thu, 24 Feb 2022 09:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645693454;
        bh=jgxNAFbFo5i1lWEOpOUAVFaQaooKHchqspipaHhzRwA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ax/l6HCoZXj8aB2eKuyynYgXe0D8c08z4twnpLIX6i+h4h5aXIcMUo4g3p53tN0LI
         2wdhgKjJN4W8SnPJt7iebQvR0OCFzkUcwW/Yc+OjUbYRxnuULiV+zftlIvO4HfVKPd
         JBrxgPavHj3DhDZaWitkwrChtGW6EQh02zQjmqDLV4z4IwkxWHOuI0wM7L9Eq1/VFq
         p+hVbj95dgq5QRtfvaCidK9O1EE/dbUN/2zd2aNuDqMJ/VtB4r3KPV1oH0IS/AIAu/
         ix7nErT30AI4Rm/lBS42hef5Dwdo3OAjB3gM4/UwUogTgVgZBmWf77MVod74eKQxH+
         q7NHsxmMRGihQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] carl9170: Replace zero-length arrays with
 flexible-array members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216194955.GA904126@embeddedor>
References: <20220216194955.GA904126@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164569345046.30378.3865257122515016490.kvalo@kernel.org>
Date:   Thu, 24 Feb 2022 09:04:12 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

152094dd8c8d carl9170: Replace zero-length arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216194955.GA904126@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

