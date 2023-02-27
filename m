Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6568D6A419B
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjB0MUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjB0MUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:20:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F09919F3F;
        Mon, 27 Feb 2023 04:19:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF811B80D17;
        Mon, 27 Feb 2023 12:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A9BC433D2;
        Mon, 27 Feb 2023 12:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677500386;
        bh=vVnZnm8G66BSDTc5sTj7XTjPa2+eT0iZSUxP75tWAWg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PRdXXUaEOzYrqi//hZexYHq92BnZL3IDLb/J++VPlBTkaRAPvAx9B4wCTXcFUHQ/H
         i65mVv/RqXF6isvh7IR1Szo58Bz1BVeWpYYuesxvbyMDB/+mGZSaIxShnG4tx1hw4q
         OH8FM34duMCOAxSuXP0aCx8UPxP2rfxahBS369NsG0QjETTlzoCsudCryCU7SsmpBG
         7i18RMDsC9bC59awupMJgD+WPAcL/IeMJmH4i6PjzXRSWrBYM29wPECbdXoQmuDeRZ
         p9cMw50LRee77sW9Elgju20NvozS7lOYS+EsChVN2UVSRJ2V25RlYBFTeeczx3WP6f
         VuqK3rYfks0LA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath6kl: reduce WARN to dev_dbg() in callback
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230126182431.867984-1-pchelkin@ispras.ru>
References: <20230126182431.867984-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oliver Neukum <oneukum@suse.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167750038173.9069.13927854450311352461.kvalo@kernel.org>
Date:   Mon, 27 Feb 2023 12:19:43 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> The warn is triggered on a known race condition, documented in the code above
> the test, that is correctly handled.  Using WARN() hinders automated testing.
> Reducing severity.
> 
> Fixes: de2070fc4aa7 ("ath6kl: Fix kernel panic on continuous driver load/unload")
> Reported-and-tested-by: syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

75c4a8154cb6 wifi: ath6kl: reduce WARN to dev_dbg() in callback

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230126182431.867984-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

