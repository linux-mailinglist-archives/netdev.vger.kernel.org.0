Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B29368D222
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 10:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjBGJIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 04:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjBGJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 04:08:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3694E25293;
        Tue,  7 Feb 2023 01:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C7A3CE1C78;
        Tue,  7 Feb 2023 09:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF9AC433D2;
        Tue,  7 Feb 2023 09:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675760923;
        bh=IMPgfkEqcwFiyajL7c6K38cwpC8Yprt9hdR3K+g10b0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=svi6jBziltLnh/GDHxX6qxdFZI8gOEZGBJrpWyxnEETZPYWV04yWU6jNXovmOV5zg
         9OE6BNgbkzt1mfiqLXm8MpCZRzj9WiIUlb+QXg0TlYwUgQEOZkfPGIJbw9dpYO/Dhs
         KOLkyWhfPckKDHv7Mk+ijwkZ3n8P25EYe3uH8PfE=
Date:   Tue, 7 Feb 2023 10:08:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jaewan Kim <jaewan@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
Message-ID: <Y+IVE2mx1+0XnJoj@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
 <20230207085400.2232544-2-jaewan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207085400.2232544-2-jaewan@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 08:53:57AM +0000, Jaewan Kim wrote:
> @@ -4445,6 +4481,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  			      NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS);
>  	wiphy_ext_feature_set(hw->wiphy,
>  			      NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
> +	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
> +
>  
>  	hw->wiphy->interface_modes = param->iftypes;
>  

Why the 2 blank lines now?  Didn't checkpatch warn about this?

thanks,

greg k-h
