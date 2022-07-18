Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130FF577F4E
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiGRKFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiGRKFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:05:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084E61C117;
        Mon, 18 Jul 2022 03:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D41600BE;
        Mon, 18 Jul 2022 10:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2637FC341C0;
        Mon, 18 Jul 2022 10:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658138723;
        bh=jQBmYBdX2gGNxydkwrFOfbWG0oW2jGpJsWf8e1m53QQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kmnSfqtP4kmOo1ohDD6CpP4vKnW+LaS5PyJTRFL59WlKpoNXapgjz9jum3Mege8Cj
         fGQOnETl4YYTMdjl51F5ubJXq0XuNWfrxIjC9inZMMrk1bSStY9H8iNGfvdpb6PP/C
         aOzop/MhPkmDZYJVXTH6SIiEqRAAbXYoLhMjVucKEFrLwFg3/ilcxzU0BnuvtKnorE
         z6CerU3SvnXINYVYxHaC29OjC/ybbbnElpLcCiwJdr/OUmaxYZF2W2bRMhA0sCzRcI
         FxcjhjWfJujWl+JOEO/riYFEDy+syHXMQPQob/PG6jXDzXaPCdhfd61EHrXKW60ZGA
         JU3uSQHVoSYcw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wil6210: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709132137.12442-1-yuanjilin@cdjrlc.com>
References: <20220709132137.12442-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165813871929.12812.893316246899205397.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 10:05:20 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'for'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

aa6f2be484d7 wifi: wil6210: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709132137.12442-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

