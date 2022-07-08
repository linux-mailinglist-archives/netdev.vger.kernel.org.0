Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11D556BB32
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbiGHNwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiGHNwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:52:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A147819034;
        Fri,  8 Jul 2022 06:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B01B8286A;
        Fri,  8 Jul 2022 13:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C84C341C0;
        Fri,  8 Jul 2022 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657288361;
        bh=dWgUfcl57UvS0TwOtzEgblzBsozkUjqJ4CbUIdLRBdc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HoXSrgvoH8IJbmahKM7OZa/dU6/k/6AVvRp1NVATCrH5EeahyuG9m/hgQZQ8i4YaJ
         3DNLvPqepGiYWY8jjRXRZTQ2F5R9vi++m2Yd8Pm4Jw5Yz7u5SEWT8iVwQMf/gXlcam
         g9NdNKhNxZvqOn/F3nqQeJFOMhwqQTfT8829UTZTV/DJXziYXbakLdkwvW/eM877bx
         SIE1ib2iLc2O8ST8pT1W33/AL+dTz5QM1TqJAt8xWI6Lo4LLBzPEIELAXZpLKgo9VI
         8VsqYco4lGLf7BZYXmPyc9yEmq7vyrj8BQLt+7jFqPChbkzf8wabdq/w8OxSqYeUCY
         L/5D+u46hx+sA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Fix typo in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220704030004.16484-1-jiaming@nfschina.com>
References: <20220704030004.16484-1-jiaming@nfschina.com>
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        renyu@nfschina.com, Zhang Jiaming <jiaming@nfschina.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165728835557.16445.10510816476274107000.kvalo@kernel.org>
Date:   Fri,  8 Jul 2022 13:52:38 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Jiaming <jiaming@nfschina.com> wrote:

> There is a typo(isn't') in comments.
> It maybe 'isn't' instead of 'isn't''.
> 
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

7d1e59a35ffa ath11k: Fix typo in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220704030004.16484-1-jiaming@nfschina.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

