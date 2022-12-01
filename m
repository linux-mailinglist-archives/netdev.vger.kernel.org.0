Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191AC63F58B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLAQqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLAQqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA88AFCE1
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9006B81F8F
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E339C433D7;
        Thu,  1 Dec 2022 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669913160;
        bh=84sxCtr+/dYdod9lsE87GdIKhsYbGlgxuVvYNXAT76U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJL3s7etnQbq0/HPqLthKNJZRfANaxZS4VPI015vpP1oemxR+684t3wg0VsU9Pnk5
         J/5kb813i3Yi1jS4ZTc/eOnY/t5RLMYRaJ4FgqYC5W7ZkI4TjXgUvk+7EpojU46HpI
         jWhYoAvoh1FBPe9YvWhygZ6FJS5JUAJCyKTht9WKfv4Gs+T+li9fNM/x/Azbi8m908
         7XSdekpEx4472Cqgv9MONw5yMUcaJaEQ3+6yY8XDzptj3cJ5827s7nqnHVe2HCknlJ
         h1rcz5yLFtzOkrCwEMj5TpUh8LoI7ii3ieViiiXqBDvYL8IYXb2AlndDr/P103ybxx
         qgL2IR93QC/5g==
Date:   Thu, 1 Dec 2022 08:45:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Jerry.Ray@microchip.com>
Cc:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221201084559.5ac2f1e6@kernel.org>
In-Reply-To: <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
        <20221130205651.4kgh7dpqp72ywbuq@skbuf>
        <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 16:42:10 +0000 Jerry.Ray@microchip.com wrote:
> get_stats64 will require PHYLINK.

Huh? I'm guessing you're referring to some patches you have queued
already and don't want to rebase across? Or some project planning?
Otherwise I don't see a connection :S
