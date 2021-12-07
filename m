Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB3F46B896
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbhLGKSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbhLGKSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:18:30 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AE2C061574;
        Tue,  7 Dec 2021 02:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=fbOS2qQiswfhsw1SwRrnERpkkSMQDodSjMAiw37a16U=;
        t=1638872100; x=1640081700; b=ZDrz5lXvTecxbw3LcGkdZS2ld0FAoI97lll/zNNQ9GFL24m
        6n0vGPOK3rQeKtNJGBqGwSx9pNz/TEyNQR8u0IcSNKjwv4shytFFNqC4Fv1iorSNlqO7Th3OPLtq1
        Z6oR0ZPamYXWztMJsfX95hKe3/nfkI3+o+KlAQmM9yAfw+WOiF4tKW7VMw4XLOoWUPyoft7SGwbkL
        nkEVSg6yAISU0VrwfQqgjsx2s5xNUbeFMyW1e7IV+DS17xKQNR0XH+HUZBKNOeIprUKW+6SiVteet
        kROqNWpF3J6k/dqx+djaEGOf1Iez7bU7be2zgXlJURa3B3ze8a0h5pFo2uBOVijA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1muXUf-0088pS-EA;
        Tue, 07 Dec 2021 11:14:41 +0100
Message-ID: <c9acebcef9504ac6889de25d528c3ea0c590b1c1.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] iwlwifi: fix LED dependencies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@kernel.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Dec 2021 11:14:40 +0100
In-Reply-To: <20211204173848.873293-1-arnd@kernel.org>
References: <20211204173848.873293-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-12-04 at 18:38 +0100, Arnd Bergmann wrote:
>  
>  config IWLWIFI_LEDS
>  	bool
> -	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
> +	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
> 

Hm. Can we really not have this if LEDS_CLASS=n?

johannes
