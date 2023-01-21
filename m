Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD66764EC
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 08:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjAUHXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 02:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjAUHXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 02:23:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C566E822;
        Fri, 20 Jan 2023 23:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 255D5CE1D43;
        Sat, 21 Jan 2023 07:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC770C433EF;
        Sat, 21 Jan 2023 07:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674285823;
        bh=YRn4dBMwH+ZRSQlmsX/X5YMtKfBtpIXEYR+/AGzCxWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZP6rtg7MbqJSV7JZ3fu6QJLQQw3wuI/hpG9ifmJWZa3weqE35G/FAAmt3GBUwoet
         zsgg5b13PI8H893M5oHZ8cU9efMKNtWPf1+mpF+MI5eBn8cqt3JNsnEqiF2Cn+JDXk
         rv6bq+uZfJYVKBOPP1crRtFO8OxIMbV4uqrqF5HQ=
Date:   Sat, 21 Jan 2023 08:23:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v4 1/2] mac80211_hwsim: add PMSR capability support
Message-ID: <Y8uS/Bw3tnPoMIK2@kroah.com>
References: <20230120174934.3528469-1-jaewan@google.com>
 <20230120174934.3528469-2-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120174934.3528469-2-jaewan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 05:49:33PM +0000, Jaewan Kim wrote:
> This CL allows mac80211_hwsim to be configured with PMSR capability.
> The capability is mandatory because nl80211_pmsr_start() ignores
> incoming PMSR request if PMSR capability isn't set in the wiphy.
> 
> This CL adds HWSIM_ATTR_PMSR_SUPPORT.
> It can be used to set PMSR capability when creating a new radio.
> To send extra details, HWSIM_ATTR_PMSR_SUPPORT can have nested
> PMSR capability attributes defined in the nl80211.h.
> Data format is the same as cfg80211_pmsr_capabilities.
> 
> If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---

Always run scripts/checkpatch.pl on your submissions before sending them
in so you do not get grumpy maintainers asking you why you did not run
scripts/checkpatch.pl in your submission :(
