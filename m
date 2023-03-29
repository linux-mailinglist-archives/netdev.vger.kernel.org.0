Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298EF6CEF12
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjC2QR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjC2QR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:17:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DFB6199;
        Wed, 29 Mar 2023 09:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C525B82389;
        Wed, 29 Mar 2023 16:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A58EC433EF;
        Wed, 29 Mar 2023 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680106617;
        bh=TWpPK393k95haP5OmkFSJZSaIGBXcPtCisO7udVorLE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mCKVLvP3ZRlmOkHI70rR6kIipm/a/7dK5KUbDGYxs9Gqqhd5gyex8NDtc419bpeT7
         3BMU/CHjXAGLydvu8fMhwsvKeynWbYt6PRVO/FbZitHvfMdlHhvf7RL4ka4SfSMzC2
         enA+1FU1D7yDaNRDWfWVK3kvdaNbJoKJs3ATVDQzBDMmz7ao4FevWcxlfa5hJ98kiL
         Jirn3Loz2fJsBlZ8N4xQzyrbVzkC5xE2UrdAY1MNy4VWs1BmMpNUyCZMfvRkoSNAEt
         3PKYjqRl0QEwJuZJI8HQ6QkY3iigioy/9XLX3grIgBDe9zlN40aIfiIOxccoo//YZi
         Ok+ClCczVnc1g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Tom Rix <trix@redhat.com>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] mwifiex: remove unused evt_buf variable
References: <20230329131444.1809018-1-trix@redhat.com>
Date:   Wed, 29 Mar 2023 19:16:49 +0300
In-Reply-To: <20230329131444.1809018-1-trix@redhat.com> (Tom Rix's message of
        "Wed, 29 Mar 2023 09:14:44 -0400")
Message-ID: <877cuzcz2m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> writes:

> clang with W=1 reports
> drivers/net/wireless/marvell/mwifiex/11h.c:198:6: error: variable
>   'evt_buf' set but not used [-Werror,-Wunused-but-set-variable]
>         u8 *evt_buf;
>             ^
> This variable is not used so remove it.
>
> Signed-off-by: Tom Rix <trix@redhat.com>

There should be "wifi:" in title, but I can add that during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
