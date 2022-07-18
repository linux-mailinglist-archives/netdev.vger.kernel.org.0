Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5EE578196
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbiGRMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiGRMHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:07:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADA4237FC;
        Mon, 18 Jul 2022 05:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F4006B811C7;
        Mon, 18 Jul 2022 12:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C58C341C0;
        Mon, 18 Jul 2022 12:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146055;
        bh=UrxKT41abmSdbKRzjqBkgtXEAHHMGNKmuOTzccd+mpQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hSByNAyDnYY5KQ71gNIXM0NnJ6VtQM0Kr4+M0xDm+X8+46S9zX2SxYMDMLiXd4qYH
         zJgmr1akBi4Yf9h+sNGv2rek66/Nb/4AIMWojJIO8bGl3/hIY4txIdm3mRhWpVQO/b
         GN7NDM0KohO75G5Ta5T8DYuTXtclia+WOEB5OvSEsrAf1VQBQhEtTcz1uWrILhAC95
         zozbsFkeiNy5rJ4rV5/26WYDlPojU0o/jIcRoz8KODhN8lniZyVlpXvYYnjbBJyrZ7
         8vd0WiDiODg+0THX0Zt+ehuI6uV2ktH0XQuc/jgCRaNs+MTbntUU6P2mz2X3Ap+fa0
         xKqUhkKyFohCg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: b43: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709133119.21076-1-yuanjilin@cdjrlc.com>
References: <20220709133119.21076-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814605166.32602.7331424475643392487.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:07:33 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'early'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

e2dfb8a5c605 wifi: b43: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709133119.21076-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

