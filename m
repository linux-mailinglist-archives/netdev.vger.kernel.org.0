Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6178D6B86A8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCNANE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCNAND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:13:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBB767702;
        Mon, 13 Mar 2023 17:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C117AB8169F;
        Tue, 14 Mar 2023 00:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6705C433EF;
        Tue, 14 Mar 2023 00:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752779;
        bh=YlxBw40HIlBNSY2QfW4UnOLi5EV5drCbXdJgxtangxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KHvUbTSo4uvCCOl6lw3+Khrq6GBVspVbI+jkbd5wtZQhzp8KmGd0Sfxa9HvGEuUZZ
         X7AA16L3Jjx/Jrakhl4JAce9lb8vRhGueuCrSnhhNTgLptZTQt7PJKuS9REV/gih/x
         Ey9s/WvLKc188dbiLvLWHMwVcOfjj0oerCSxXMySR/AKmaPBGGJ+xRoUCyeXtnh/St
         hMt+UNlO32OPBUq6tB/3TQDAZouz/WtVjuzP7FtYrdRzb0q1VpTXhTvJ6UORNPCGxI
         /QBYsjoOMupQVFaf3Bevq45SSPsC4Ep51LwCBy3gN23W74Vzxdy01R5CrhK33IH2R0
         E4bnWY34vm+sQ==
Date:   Mon, 13 Mar 2023 17:12:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        luca.weiss@fairphone.com, dmitry.baryshkov@linaro.org,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: fix a surprising number of bad offsets
Message-ID: <20230313171257.225f2fa0@kernel.org>
In-Reply-To: <20230310193709.1477102-1-elder@linaro.org>
References: <20230310193709.1477102-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 13:37:09 -0600 Alex Elder wrote:
> Fixes: 59b12b1d27f3f ("net: ipa: kill gsi->virt_raw")

For the future - please try to avoid overshooting the number of
characters, checkpatch seems to dislike that.
