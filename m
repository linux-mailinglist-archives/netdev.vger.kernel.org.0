Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C166F1CFA
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346387AbjD1QyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346032AbjD1QyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:54:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423295B90;
        Fri, 28 Apr 2023 09:53:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C65F464499;
        Fri, 28 Apr 2023 16:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E734FC4339B;
        Fri, 28 Apr 2023 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682700823;
        bh=JWcTQJX9/X961Kb33b8lpvZkffh9I4opvz78Yme+I34=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LElNgJk2lRyREgMTcx1yV5uEziuSRyP/8kL6p5ughYoSg6JCZcnc2PYQGnrX5Hcji
         07HM8oodBhOnfk9Zv7cG9SXbL9TsT7BCcXFceWQ7PQySmwOtkXXvd9NB9Swnh9CEza
         3k4GQ02Lra7IvjvXEMM+qwcQRhSNW6QWuzm8s01e/G1ismv7kXBwMH/Up5v+X1Iesy
         puXFqwWlcWH4PKP9hkE+70FdOr7ESP6s2VHchcRXk40Wu3iKJ1Gsl5GcXWWAA9wiyv
         u20+rw6IN0yaIbCy1Lw/6P1V96K76uI/9aChA36hupNd13w0M8FTruGpdI5z9jXwty
         h5drrQMjELaAw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath12k: Remove some dead code
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <c17edf0811156a33bae6c5cf1906d751cc87edd4.1682423828.git.christophe.jaillet@wanadoo.fr>
References: <c17edf0811156a33bae6c5cf1906d751cc87edd4.1682423828.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168270081882.13772.3615961159220627233.kvalo@kernel.org>
Date:   Fri, 28 Apr 2023 16:53:40 +0000 (UTC)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> ATH12K_HE_MCS_MAX = 11, so this test and the following one are the same.
> Remove the one with the hard coded 11 value.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

33f83a23f4cc wifi: ath12k: Remove some dead code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/c17edf0811156a33bae6c5cf1906d751cc87edd4.1682423828.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

