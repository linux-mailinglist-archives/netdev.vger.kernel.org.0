Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B39615A41
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiKBD1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiKBD1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:27:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5269626109;
        Tue,  1 Nov 2022 20:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F10F1B8205C;
        Wed,  2 Nov 2022 03:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4174DC433D7;
        Wed,  2 Nov 2022 03:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667359661;
        bh=llALIh8Hrutu6IChgEIOcVbBiY23nBZWEke74EjmRyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8zltxDPx4jS4CBkHb4TLvhUi98LbzMZ47fzvQ81O9JLJvRgYYvncnq35vFFRu8GP
         KYKtWvjXLgAUy+BBZoDg6LdeBP5deQ1qv2Qn7PFxlVayIrm/4+BhUlaGjl7TWOiPaG
         VB8+RawCwTIrn95Xkh54efMyIiTZh/HfLpGwYdtJEwO1YrR+ZjbzfuiwB4DdDpryTG
         VybtagmM7BqYtWP548b1apqllyWzn42USuZN7uhZ9mZKwNDn0Q9iB0Sl70sVoGBb/+
         vWGIqmj03DLutfZ2Xv/+Sg3l0zzRMzykYnFsFqPZe1/SQYGC9MgDewMWKz+DacTuyQ
         Ymw1pFfXI3klA==
Date:   Tue, 1 Nov 2022 20:27:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/30] net: usb: Use kstrtobool() instead of strtobool()
Message-ID: <20221101202740.3949b091@kernel.org>
In-Reply-To: <d4432f67b6f769cacdabec910ac723298964e302.1667336095.git.christophe.jaillet@wanadoo.fr>
References: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
        <d4432f67b6f769cacdabec910ac723298964e302.1667336095.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Nov 2022 22:13:49 +0100 Christophe JAILLET wrote:
> This patch is part of a serie that axes all usages of strtobool().
> Each patch can be applied independently from the other ones.
> 
> The last patch of the serie removes the definition of strtobool().
> 
> You may not be in copy of the cover letter. So, if needed, it is available
> at [1].
> 
> [1]: https://lore.kernel.org/all/cover.1667336095.git.christophe.jaillet@wanadoo.fr/

Please repost this patch separately. Patch bots and CIs will not test
partially received series.
