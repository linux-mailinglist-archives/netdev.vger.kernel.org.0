Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297DD633835
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiKVJU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiKVJUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:20:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F56424BE9;
        Tue, 22 Nov 2022 01:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B217AB819B9;
        Tue, 22 Nov 2022 09:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C92C433D6;
        Tue, 22 Nov 2022 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669108808;
        bh=NbGvNB2Wd5BkKCbJfV2MJrvrLgQTqRqPrud+0q1AHGc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G3fdC3fSM/2IGWXcZaygL7qTuw4czhphLrdq0EIsh85Nm8doX5bGXM8RLH5VS0ois
         L3dFcI5yKbiIZPKvd5InCpo5uJ2iX29omRJH1nXwN6OGv2fbo47/AdqMFXa/VGCHYn
         SL1Fvu+IHWO6dl6WmAq5wonQBmHSk6Wh6g3BoI4+uPb1uMNTIL7TS5qOX0TXS0MRcz
         XJkd3f/0AcfsTkCNr0DnHWQMH9qItcqgwOkx5ZElW7cPqMOE8qdhwPIwpGjetObxd4
         nCudnx2mP4YJyWrD8qYci52iGp/HbAKr4IAjvU0qoaFyTe+7lqavaOS2W/Fmn8aiu9
         +VbpU9TIrgaIw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: MAINTAINERS: mark rsi wifi driver as orphan
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221113185838.11643-1-marex@denx.de>
References: <20221113185838.11643-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166910880351.6391.3659600506041948858.kvalo@kernel.org>
Date:   Tue, 22 Nov 2022 09:20:05 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> Neither Redpine Signals nor Silicon Labs seem to care about proper
> maintenance of this driver, nor is there any help, documentation or
> feedback on patches. The driver suffers from various problems and
> subtle bugs. Mark it as orphaned.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Patch applied to wireless.git, thanks.

2d0b08c15743 MAINTAINERS: mark rsi wifi driver as orphan

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221113185838.11643-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

