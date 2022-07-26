Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44D8581538
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbiGZO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiGZO2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:28:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6F0B9;
        Tue, 26 Jul 2022 07:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D1D5B81644;
        Tue, 26 Jul 2022 14:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0371CC433D6;
        Tue, 26 Jul 2022 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658845680;
        bh=tYGaxmOtEWct+hY2SoBnCZGzvOcL/UBUptCOL4UpjVI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UE9AOoyfew0LRVvAXnX/z7P9HC5z/3chQoC4Y3lmgaPJCwuGsji/aJoMr8iVnCY6H
         Ke9phrGkuaIY1ItJOKTkT5QCMPoPOJup8vfq98c6iGA2NjNjcvEWM/n9hPD1isbgD0
         tUdeZL5JgERnrCU9lPl9xq1sclipC9cUyXJaxWowLkORPBX7LU929UR09F7gcUwS52
         LkEmBiGr/9qR31PR8nL3EEqsQl4qbvu8aXnBsTP/1btUn2MFrDBVXYLGxIZ7ZvALsO
         Kycmnr5E/RXL2MNzC8CEkGg+DcZKufVAFTM5Xv1k+R21EJTNk/CXqc/Bg+AclmEchj
         2AlSfSXxwH3hg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] iwlwifi: mvm: fix clang -Wformat warnings
References: <20220711222919.2043613-1-justinstitt@google.com>
        <CAFhGd8qRfhQg2k8E7pUm5EYSLp+vmtSd5tZuqtpZUyKud6_Zag@mail.gmail.com>
Date:   Tue, 26 Jul 2022 17:27:53 +0300
In-Reply-To: <CAFhGd8qRfhQg2k8E7pUm5EYSLp+vmtSd5tZuqtpZUyKud6_Zag@mail.gmail.com>
        (Justin Stitt's message of "Mon, 18 Jul 2022 10:37:05 -0700")
Message-ID: <87sfmoq786.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Justin Stitt <justinstitt@google.com> writes:

> Any chance a maintainer could take a look at this patch? I am trying
> to get it through this cycle and we are so close to enabling the
> -Wformat option for Clang. There's only a handful of patches remaining
> until the patch enabling this warning can be sent!

Gregory, can I take this directly to wireless-next? I assigned it to me
in patchwork.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
