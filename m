Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1DB1F54BA
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 14:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgFJM02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 08:26:28 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36642 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729140AbgFJM02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 08:26:28 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[127.0.1.1])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jizng-0015Qs-DI; Wed, 10 Jun 2020 15:25:48 +0300
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Luca Coelho <luca@coelho.fi>
In-Reply-To: <20200605154112.16277-7-f.suligoi@asem.it>
References: <20200605154112.16277-7-f.suligoi@asem.it>
To:     Flavio Suligoi <f.suligoi@asem.it>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johan Hovold <johan@kernel.org>,
        Saurav Girepunje <saurav.girepunje@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Flavio Suligoi <f.suligoi@asem.it>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.8.3
Message-Id: <E1jizng-0015Qs-DI@farmhouse.coelho.fi>
Date:   Wed, 10 Jun 2020 15:25:48 +0300
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH 6/9] net: wireless: intel: fix wiki website url
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flavio Suligoi <f.suligoi@asem.it> wrote:

> In some Intel files, the wiki url is still the old
> "wireless.kernel.org" instead of the new
> "wireless.wiki.kernel.org"
> 
> Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>

Patch applied to iwlwifi-next.git, thanks.

e00c6d8d491b net: wireless: intel: fix wiki website url

