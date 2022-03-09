Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE34D317A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbiCIPKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiCIPKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:10:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8D090240;
        Wed,  9 Mar 2022 07:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2B29B821FF;
        Wed,  9 Mar 2022 15:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B165DC340E8;
        Wed,  9 Mar 2022 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646838592;
        bh=nlUaNk9bY6EfkD+oDTPEyKDXgh7OGa9FI2uCA9DyBM8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RyYN/a7lh/Zy4q3hcmjkEcNr/UZ+jDKVGw/AtQ52E7xB5tk5g/uKmdkODGNJSXmVZ
         MP5VO7SKfQAbHqAyAxFG9yAdzayOXIUcUiO8nDgX10QKu4i+fRiLg/kGTwDxUEjLOf
         ioETIbFIfpocM4J/bHW/6I2087+0r+qURuh5wr4uPHSkKPC1K9lKwGHFiVbTjKje14
         65TmuGXEzeOV20MM6JLQhZOkxtOOQb82sY7oAgJzLIIL3N8GCv+EWwIXlvZEUN/BNy
         SCdY3SMoINBGZrZpMZjEXqi39eVD1N3hQiQg27pYimRgc1d8nobEd/r2qsqkdEHG8j
         St29PIhbNO7lg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: make array voice_priority static const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220222121749.87513-1-colin.i.king@gmail.com>
References: <20220222121749.87513-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164683858847.5166.9996410322468907299.kvalo@kernel.org>
Date:   Wed,  9 Mar 2022 15:09:50 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Don't populate the read-only array voice_priority on the stack but
> instead make it static const. Also makes the object code a little
> smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

44d445c02388 ath9k: make array voice_priority static const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220222121749.87513-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

