Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A256BB42
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbiGHNxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238339AbiGHNxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:53:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6952013D1A;
        Fri,  8 Jul 2022 06:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01F5A62766;
        Fri,  8 Jul 2022 13:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF48C341C0;
        Fri,  8 Jul 2022 13:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657288415;
        bh=uBLmO47kD8WPS5f9UmgNe3cUFBZ86nXkF4XQJEPlraE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=S0gnO2p370krUmpkAvZlJGLDN3GqzVgGV5haXPw7UUf6nSDJTd2txKzqPqaZ/gpco
         KQRrbwdns5HwhA9Vw991Q9P3y9spV4AGEfQMJ139p/oPps8u3l+0hW1slXaK2AgUJL
         QDFoeJ6bNP6QIlIk9ZtJz2cS1nRhSPHcxjdhaERkcWcndmGCNUf+6rNTjUIOd/Eftm
         qU6SWC7R3BnPCXgf6aI6sz3wfZFfVpxAlbRSHWks1M32oO/xVQt2EMbmTHrZzw3tHT
         FVcxvVr4awqcBg2wH8+5fEI+5llnhQVdma0qdDAktaweGiUfAjS7OHgp0sgPdHGcyQ
         ZWPbZs+mevssg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: remove unexpected words "the" in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220621080240.42198-1-jiangjian@cdjrlc.com>
References: <20220621080240.42198-1-jiangjian@cdjrlc.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     toke@toke.dk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165728841117.16445.13979339928624237547.kvalo@kernel.org>
Date:   Fri,  8 Jul 2022 13:53:33 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiang Jian <jiangjian@cdjrlc.com> wrote:

> there is unexpected word "the" in comments need to remove
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d1954e3e1b66 ath9k: remove unexpected words "the" in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220621080240.42198-1-jiangjian@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

