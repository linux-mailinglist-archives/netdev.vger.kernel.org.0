Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50615781A8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiGRMJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiGRMJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58EB24943;
        Mon, 18 Jul 2022 05:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AEC6146C;
        Mon, 18 Jul 2022 12:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3242DC341C0;
        Mon, 18 Jul 2022 12:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146115;
        bh=D7RMYd7Ve71tRWfEkUPhBapH873/N/65b7fdhub7W44=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UaFDFGgB+1V+/T706rv4yHCOKqV7xxwZlDCYjAfwXwe8cSLiZuu+Xb0vdN41FUb6w
         EDvmptxZv3z3kVh88Nyy6BjOfrobyIL9SE+O3DeElkjbC55c2d4DSd4pn7dN1bMXVX
         X1NbhO9d5KAvJAltZhHjRA+Fyb2i/bolRU6b3gXdqqQt+cZtTm/RpJl3h8KMr+RiXX
         ujnQ9ZPj6f3BZ1jrcMp6ZD17hJzIN2BDsqw2iTosIHgH9x34CtX1XD15e3vILjWTVo
         vSCbYo9PWRa2yviIK2lr4cLd1uNzag7/ubZiheZ7g/g5tofUiN1AsiNr9IU0Y4TTNk
         Hk3UzPCdJeGTA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ipw2x00: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709134701.36081-1-yuanjilin@cdjrlc.com>
References: <20220709134701.36081-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814611117.32602.8723750164153329355.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:08:33 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

ac15a010b664 wifi: ipw2x00: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709134701.36081-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

