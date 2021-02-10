Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1C23165F0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBJMDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:03:55 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:45028 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231319AbhBJMCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:02:01 -0500
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2021 07:02:00 EST
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l9nls-0049Tk-1p; Wed, 10 Feb 2021 13:35:00 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <20210112132449.22243-3-tiwai@suse.de>
References: <20210112132449.22243-3-tiwai@suse.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.9.1+
Message-Id: <E1l9nls-0049Tk-1p@farmhouse.coelho.fi>
Date:   Wed, 10 Feb 2021 13:35:00 +0200
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH 2/2] iwlwifi: dbg: Mark ucode tlv data as const
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> The ucode TLV data may be read-only and should be treated as const
> pointers, but currently a few code forcibly cast to the writable
> pointer unnecessarily.  This gave developers a wrong impression as if
> it can be modified, resulting in crashing regressions already a couple
> of times.
> 
> This patch adds the const prefix to those cast pointers, so that such
> attempt can be caught more easily in future.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to iwlwifi-next.git, thanks.

71b6254a6c98 iwlwifi: dbg: Mark ucode tlv data as const

