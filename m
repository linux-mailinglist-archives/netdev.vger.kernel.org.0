Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558D045639F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhKRTso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbhKRTsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 14:48:43 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9730C061574;
        Thu, 18 Nov 2021 11:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=YQZLKIAQX/7i026JYisn1BPQuqEVD/2BD06l661YaYw=;
        t=1637264742; x=1638474342; b=fcrHXOD9MEyTVGT4c1p88yBQCT7kApzH1AE6DplKLlDa4nH
        YilGlS5CgVU5ZwKmm6ri5lTjs2b4FL5b8D0Othp7Q+IzqniGpBpg0ko3wW2WqkMkDVCBjrL0L5IvJ
        xiS/r66zY3sXdARTP9Q01S1DYJ3Wfp7GSrlKG64c5W9FSKLRFzI+hI0hEfLaptu4VO2TnLTI3+fsb
        4l4Btr/vRewzUTX79R7tUOSiWUuSfsjz3mfHdmeQeOScvPPNdOolS1G/TyRX5E5qs9O9L12pjIhAG
        2TY4THJg30iFcOEsD7M2GGtkCSB5MqXzuogSVhSOS2QF5PT5snB3ux7OhLL1is6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mnnLY-00H8Qc-40;
        Thu, 18 Nov 2021 20:45:24 +0100
Message-ID: <147e31ef85dbbdf87d6785b6a28229de81f8af6c.camel@sipsolutions.net>
Subject: Re: [PATCH] mwl8k: Use struct_group() for memcpy() region
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Allen Pais <allen.lkml@gmail.com>,
        Zheyu Ma <zheyuma97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Thu, 18 Nov 2021 20:45:22 +0100
In-Reply-To: <20211118183700.1282181-1-keescook@chromium.org>
References: <20211118183700.1282181-1-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-18 at 10:37 -0800, Kees Cook wrote:
> 
> -	__u8 key_material[MAX_ENCR_KEY_LENGTH];
> -	__u8 tkip_tx_mic_key[MIC_KEY_LENGTH];
> -	__u8 tkip_rx_mic_key[MIC_KEY_LENGTH];
> +	struct {
> +			__u8 key_material[MAX_ENCR_KEY_LENGTH];
> 

That got one tab too many?

johannes
