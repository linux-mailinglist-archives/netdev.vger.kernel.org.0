Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D2C6BAD5D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjCOKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjCOKQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:16:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C449762867;
        Wed, 15 Mar 2023 03:16:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F97C61CB0;
        Wed, 15 Mar 2023 10:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B750C4339B;
        Wed, 15 Mar 2023 10:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678875359;
        bh=dU40N6WtaC54YJLo2YP9gjtbpST/CaEE0FGBqpswX2M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RutcV0T2WyEKQlIYUrbXccGu9CVE+YtsgHnBpiq5+PkpLmwZAWwEkKCeA8tZuac6J
         +TWMQqIY8qiG6MV9QivS9TfrwD5fF5aV3Kg2LZOG2sVGHjMBl9pLDXAPkwhVejGxdu
         iq2H2H06ryN2Lwk3nUPZFddiS6yar9vpuKTI/ffbaFtrIvrw1yLEXJlkE4ZnqWqYcl
         zQ7fgPpShwlaMirz1zRRcAUge7KIlpdok8nyvHQl/hg8nkVxLHGAQSg88M+Q7f9KgL
         xnxB+9mscB1W10wKq4f7OKFBYNZt+DJywfCG+NRl0ZNHdWgm5TKBhHarvUBwogQkM2
         3c9sz+9/gduQA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/1] net: wireless: ath: wcn36xx: add support for
 pronto-v3
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230311150647.22935-2-sireeshkodali1@gmail.com>
References: <20230311150647.22935-2-sireeshkodali1@gmail.com>
To:     Sireesh Kodali <sireeshkodali1@gmail.com>
Cc:     loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        linux-kernel@vger.kernel.org,
        Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167887535507.21988.3101268581482537210.kvalo@kernel.org>
Date:   Wed, 15 Mar 2023 10:15:56 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sireesh Kodali <sireeshkodali1@gmail.com> wrote:

> Pronto v3 has a different DXE address than prior Pronto versions. This
> patch changes the macro to return the correct register address based on
> the pronto version.
> 
> Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

f94557154d9f wifi: wcn36xx: add support for pronto-v3

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230311150647.22935-2-sireeshkodali1@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

