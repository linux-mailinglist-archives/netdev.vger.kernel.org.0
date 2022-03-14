Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32B4D8BAF
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243817AbiCNSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiCNSV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D35335241;
        Mon, 14 Mar 2022 11:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDF24B80EDD;
        Mon, 14 Mar 2022 18:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADB1C340F5;
        Mon, 14 Mar 2022 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647282016;
        bh=aVhb63UNW3shumzhWS/giLitMgkS3X7L319NqunTbdg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tWhjKLFZ9WkZV7v07USE02UKOmm67zfl2QTaJuw7liaX61TvJiuTQc2qXkaDQQncW
         iDrTMCoZ+dssPoPaL2/ggoF2v4OycHp7rwju2nbTBWHNQQNP15cjg++cMbwzThlLEj
         UdpqhNNGEsrZRqQE+I0IajoOOPzKWjNaynlxf5RhqCFOZNGX10FOwALM0/TDw1s0t0
         KV/HbVWfbcXE2gghUcmhK10KauF5JNyX2Ouqk/8x1UHjJYdWMLEB5Eee5GdnKA45TH
         1Uu1AjJPsHxBbw1ixapZuN4xsCuhprMkpNTKmOcS9tnZv5RZbgxaELW3spNQN1vUjb
         Aj02mb0G2o6yg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <20220311130530.70d9faa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 14 Mar 2022 20:20:13 +0200
In-Reply-To: <20220311130530.70d9faa6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 11 Mar 2022 13:05:30 -0800")
Message-ID: <87wngwwg4i.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 11 Mar 2022 13:40:28 +0100 Johannes Berg wrote:
>> Hi,
>> 
>> Here's another (almost certainly final for 5.8) set of
>> patches for net-next.
>
> 5.18 ;)
>
>> Note that there's a minor merge conflict - Stephen already
>> noticed it and resolved it here:
>> https://lore.kernel.org/linux-wireless/20220217110903.7f58acae@canb.auug.org.au/
>> 
>> I didn't resolve it explicitly by merging back since it's
>> such a simple conflict, but let me know if you want me to
>> do that (now or in the future).
>
> Looks like commit e8e10a37c51c ("iwlwifi: acpi: move ppag code from mvm
> to fw/acpi") uses spaces for indentation?

Luca, can you check that, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
