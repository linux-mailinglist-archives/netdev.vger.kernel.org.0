Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49580686590
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjBALtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBALts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:49:48 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A985261863;
        Wed,  1 Feb 2023 03:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=hGdzvQb40gV8ZBMXc3N7o2HWe0+utw5NUr82qAgdCSk=;
        t=1675252187; x=1676461787; b=XFyOTG+WsG+W47kjiwhlbOSQFxUeImW5KIL+ngtct6ZttXi
        t5mF8peiqR3pOZ86c+Bp5Gmz4zCFphHgiRDWcGjzxeUm/MW9ho3PtOCb3IQAlLh6Tzz9xo9r9o/zY
        FTjm0s3vpmaVOsEUPQPWxHV9ezC0RozXsYKIxBWUa5Yx2YbERhY8jcgk2s2F6Xkf4AVZf+nbm2eSJ
        EVSxd4AA7OOOhKZDL6W3ToKBd2tWrAFwXcpV+pPkLFNOqKiFjL2WHD6+M7i/xpE6eOTPOB7F6WtXH
        gs2tALSJQ55gB82kvdu53M3Q3FhG65WYg+Do+tR9J6wj1nt/yRdXzPoLAmFPJrqA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pNBcL-000GaJ-09;
        Wed, 01 Feb 2023 12:49:33 +0100
Message-ID: <fdea34a70013891fd4d77e9e6a8e49d567446f15.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: rsi: Adding new driver Maintainers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ganapathi Kondraju <ganapathi.kondraju@silabs.com>,
        linux-wireless@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Marek Vasut <marex@denx.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        netdev@vger.kernel.org,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        Angus Ainslie <angus@akkea.ca>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        narasimha.anumolu@silabs.com, amol.hanwate@silabs.com,
        shivanadam.gude@silabs.com, srinivas.chappidi@silabs.com
Date:   Wed, 01 Feb 2023 12:49:30 +0100
In-Reply-To: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
References: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject should say "add"

On Mon, 2023-01-30 at 15:09 +0530, Ganapathi Kondraju wrote:
> Silicon Labs acquired Redpine Signals recently. It needs to continue
> giving support to the existing REDPINE WIRELESS DRIVER. Added new
> Maintainers for it.

That should also say "add".

johannes


