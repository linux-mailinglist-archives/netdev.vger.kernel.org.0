Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970176E4508
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDQKUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjDQKUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE002D62;
        Mon, 17 Apr 2023 03:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D1D6619F7;
        Mon, 17 Apr 2023 10:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4133C433D2;
        Mon, 17 Apr 2023 10:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681726653;
        bh=/fPCzxyxSiGP6+JHJKOXA+nXbM/XfTTQ4dmQysYc8xM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AxEDjweu9kmtwN8nD6Zyc7Mkcv1dAB/6Ld/IKmFw4kZoWBEkhDai0HgF2x1Aw7LGy
         qGwlzNYfBgl29sM3xECPdKGL4HyoEZKjhvzC0t6OXhdb0wIgRd0c8AVV51JAyjDzt5
         JdE1JJBuPxP4D982s61OWzQG+Y0qvKY0WOGE+OM5tSe9CSK2857oyXEtSRy7FQ3WOh
         fsUpeHjdDP1V5r3esIb9h5QSeC8d3ck5BHk0gK9WDRh+CtReq/IVpG4Jmn6ilDYW5n
         VHruYFJ/snxtyU3doYDgaiAVUEXaHtjwd8SsTTaHpwdWBCxYdzK0yQe3hiwK7jFo+Z
         uekvOq2kmg1Rw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: pci: Add more MODULE_FIRMWARE() entries
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230330143718.19511-1-tiwai@suse.de>
References: <20230330143718.19511-1-tiwai@suse.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168172665084.12889.1483774754655787477.kvalo@kernel.org>
Date:   Mon, 17 Apr 2023 10:17:32 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> As there are a few more models supported by the driver, let's add the
> missing MODULE_FIRMWARE() entries for them.  The lack of them resulted
> in the missing device enablement on some systems, such as the
> installation image of openSUSE.
> 
> While we are at it, use the wildcard instead of listing each firmware
> files individually for each.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

06c584739692 wifi: ath11k: pci: Add more MODULE_FIRMWARE() entries

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230330143718.19511-1-tiwai@suse.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

