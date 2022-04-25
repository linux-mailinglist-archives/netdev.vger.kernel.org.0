Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAD450E12C
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiDYNKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiDYNKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:10:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40019205EE;
        Mon, 25 Apr 2022 06:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 562C6B8165D;
        Mon, 25 Apr 2022 13:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D56CC385A4;
        Mon, 25 Apr 2022 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650892013;
        bh=8n1gEd9zrEZzTMEw2QahiJ2pqS9bWSF+C0RowIh4NBg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VtCn3hMiCg0c/Cf790/jHadQRUztU5dh0jhqh9WgQl14BQoadkh0tcxLs311WVMPw
         I7ir48LBf2MsxXiNF9QyRlzPQqwroPA2D1F/uXhL5G2IYvLS68H4sbqafoyfB91kPn
         b9vesaiVI1xNI4Ti0C7L0jFAG8PpVW7Rw4WJI1RPV2a1MAHV7bQXQGCu1aWnDnSQk/
         riaRqtxKguxXO6sYFnrGvZCKrIaFIJEUEnDAuQycWTleAK2ocLgKoJNtY1xZqxtgj5
         M8O6V5jD9VDcV1GwNfdJJ0mn4Qsrv+INZ35EMhsdFNvNYtEbVpvM6TyVq01S3LRjeA
         cVOY12R7AjMxQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v22 1/2] wireless: Initial driver submission for pureLiFi
 STA
 devices
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220224182042.132466-3-srini.raju@purelifi.com>
References: <20220224182042.132466-3-srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165089199642.17454.12727074837478904084.kvalo@kernel.org>
Date:   Mon, 25 Apr 2022 13:06:51 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> This driver implementation has been based on the zd1211rw driver
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture
> 
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

While reviewing this for the last time I did some minor changes in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/commit/?h=pending&id=68d57a07bfe5bb29b80cd8b8fa24c9d1ea104124

Here's the commit log I plan to use:

    wireless: add plfxlc driver for pureLiFi X, XL, XC devices
    
    This is a driver for pureLiFi X, XL, XC devices which use light to transmit
    data, so they are not compatible with normal Wi-Fi devices. The driver uses
    separate NL80211_BAND_LC band to distinguish from Wi-Fi.  The driver is based
    on 802.11 softMAC Architecture and uses native 802.11 for configuration and
    management. Station and Ad-Hoc modes are supported.
    
    The driver is compiled and tested in ARM, x86 architectures and compiled in
    powerpc architecture. This driver implementation has been based on the zd1211rw
    driver.

And the list of changes I made:

* rewrote the commit log

* change MAINTAINER to be only for plfxlc

* CONFIG_PURELIFI_XLC -> CONFIG_PLFXLC

* purelifi_xlc.ko -> plfxlc.ko

* improve Kconfig help text

* _LF_X_CHIP_H -> PLFXLC_CHIP_H

* PURELIFI_MAC_H -> PLFXLC_MAC_H

* _PURELIFI_USB_H -> PLFXLC_USB_H

* upload_mac_and_serial() -> plfxlc_upload_mac_and_serial()

Unless I don't get any comments I'm planning to merge this on Wednesday.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220224182042.132466-3-srini.raju@purelifi.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

