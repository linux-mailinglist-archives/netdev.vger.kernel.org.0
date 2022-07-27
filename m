Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5E582508
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiG0K7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiG0K7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5D48EBF;
        Wed, 27 Jul 2022 03:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99BF3B82011;
        Wed, 27 Jul 2022 10:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21548C4314E;
        Wed, 27 Jul 2022 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919566;
        bh=3mgOY3AxsiCz7mK1KuMNARoV9jRKh6rVye+yrgcONBg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WWNDM8vwpZwcOjRjBS17g0CKEACQrfyqEifYzTJV9uV2HwHj/QNec2EaQGWufpZbi
         zX7hD/e9lpDf17PxwKl5aZZUReMCG9FtHDGvF0M+oozLhiYDHq7aCYjWjZpQndON2U
         e1O+SRRFYrcYYZ8YNhuNYIUTG7CKqfx1gdAeF003F5fOoV7DfZ/KBoIm4+I0qLXfc6
         nOb8wSGdZuq7g6MrkHpcMx17xk8AIYPOX+Q9n54Ki2sl5RQTaLzONZRzpi23sBdl5Q
         PUZfsK/akktqv0rzmcl2rxobkCdmV+aNVlpeGciIfr9lpNuc73L6R4AhQkCt76nL2b
         8I/91Oxi1TZBQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: qtnfmac: Fix typo 'the the' in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220722084158.75647-1-slark_xiao@163.com>
References: <20220722084158.75647-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     imitsyanko@quantenna.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, geomatsi@gmail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891956220.17998.17011028185812391455.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:59:23 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slark Xiao <slark_xiao@163.com> wrote:

> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Patch applied to wireless-next.git, thanks.

974d8c16321c wifi: mwifiex: Fix comment typo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220722084158.75647-1-slark_xiao@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

