Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5E3583984
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiG1H25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiG1H2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:28:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF605F9A1;
        Thu, 28 Jul 2022 00:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E69ABB82326;
        Thu, 28 Jul 2022 07:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25548C433D6;
        Thu, 28 Jul 2022 07:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658993332;
        bh=O/JP6b787a9xdxS67CTuLZkxu/lZwZItMs0m4UYXNjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LbTL8FsELlSzraB8WGi12+Q0duYn4N/Gu8P12hwin9VnU/E43BSPLJVc6JNHbHe6X
         44Oj3PFvQ1HlHv2xypMt4LgcAygS5vIxxGinm8pWYFUOpR7KYWSTtklHTlHlSJMUBe
         OS2oGJvtR4FBHXKP3Fl6wKKD8Caf0ru14rYZPjpw=
Date:   Thu, 28 Jul 2022 09:28:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, naresh.kamboju@linaro.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state()
 for now
Message-ID: <YuI6shUi6iJdMSfB@kroah.com>
References: <20220727185012.3255200-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727185012.3255200-1-saravanak@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 11:50:08AM -0700, Saravana Kannan wrote:
> More fixes/changes are needed before driver_deferred_probe_check_state()
> can be deleted. So, bring it back for now.
> 
> Greg,
> 
> Can we get this into 5.19? If not, it might not be worth picking up this
> series. I could just do the other/more fixes in time for 5.20.

Wow, no, it is _WAY_ too late for 5.19 to make a change like this,
sorry.

What is so broken that we need to revert these now?  I could do so for
5.20-rc1, and then backport to 5.19.y if that release is really broken,
but this feels odd so late in the cycle.

thanks,

greg k-h
