Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FB2517CD3
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 07:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiECFdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 01:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiECFdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 01:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DED0387A7;
        Mon,  2 May 2022 22:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A966154D;
        Tue,  3 May 2022 05:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CF5C385A9;
        Tue,  3 May 2022 05:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651555781;
        bh=yMBoWF0nvWgsPkJx/J8zK0TimF5+YRey0fH4qHkvjTA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ufVas6kp1YoKwK8wNMl2zHcgQceNACHjhAi67pGAK/YEWI7m68RI4dhVVgq0YSfvf
         Mh6jU5Rn2VA8jT730/Uis9SxmWGAQzOTtsovLx0wrsZ58d9ekkM1xfUHTF8QGZydN0
         IbKqc/rT2nDRNugFw+Vt5dXbRUTXHTpomfPW35pLm08MjNo+kyCSxNS8j/EStfJGHl
         AJKvIl2A0AotfnkG/ry4EQYC39FYs2z0vyqxxLwVwWtDGlqcXW0kqPcA0yOgGdPObh
         hMBcNqRUCA9qxBz3jSg1j+cxLgjSAOCKYxCc22GLnQa6BGl1PkmmAG5qc8nUWPGwtN
         msbtKXyW0VwQQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] [v4] plfxlc: fix le16_to_cpu warning for beacon_interval
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220502150133.6052-1-srini.raju@purelifi.com>
References: <20220502150133.6052-1-srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Srinivasan Raju <srini.raju@purelifi.com>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:PURELIFI PLFXLC DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Srinivasan Raju <srini.raju@purelifi.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165155576592.23375.9180707873462805854.kvalo@kernel.org>
Date:   Tue,  3 May 2022 05:29:39 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> Fix the following sparse warnings:
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

Patch applied to wireless-next.git, thanks.

ccc915e7dd7e plfxlc: fix le16_to_cpu warning for beacon_interval

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220502150133.6052-1-srini.raju@purelifi.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

