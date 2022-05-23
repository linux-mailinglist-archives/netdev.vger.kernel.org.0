Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86445313A3
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbiEWP6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbiEWP5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC7D58381;
        Mon, 23 May 2022 08:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F026135B;
        Mon, 23 May 2022 15:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4B5C385A9;
        Mon, 23 May 2022 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653321423;
        bh=ujayOaH3fjlY8iDthmcKzv6/JmxtEhUomVjdt+Jmwgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tgvNPMWMR0DgzsbPzEbFoxMDB6bdBKwsJmcScuoqzOwqN+32MpayMUKnszr1vvDNH
         l1dNRJ9hbfmHRFzD7jtjyds1SkEHNlimzj9CStprKh0i+R/oDYFJmlGy9a9TgxoCWw
         dLxgF12dvdatwSZ80zFFuMAl87xArpCNvUe41bOJNcy5uZxC566UrFd3dPN1DjM08g
         rtN/sRNCqfsvUYYrltioDX8YXqbmOZJUulbNryeZ1gkTeXg9Myw+BEKoWo0r1JqEQt
         86PYjA6OY3tcKv7rMypvwqRShwXKW3lUXvscf711eUT4gmfSKjNQKhfWWs492B4W5D
         C8inFW3952WjQ==
Date:   Mon, 23 May 2022 08:57:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "colin.king@intel.com" <colin.king@intel.com>
Subject: Re: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true
 condition pointed out by GCC 12
Message-ID: <20220523085701.3d7550ff@kernel.org>
In-Reply-To: <8fb9d491692a4a2dabe783ffefc76ded@realtek.com>
References: <20220520194320.2356236-1-kuba@kernel.org>
        <20220520194320.2356236-4-kuba@kernel.org>
        <8fb9d491692a4a2dabe783ffefc76ded@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 02:35:32 +0000 Ping-Ke Shih wrote:
> This is a typo since initial commit. Correct it by
> -			     value[0] != NULL)
> +			     value[0][0] != 0)
> 
> So, NACK this patch.

Too, late, the patches were already applied, sorry. Please post a fixup.
