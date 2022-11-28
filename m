Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D87463A0E8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiK1Ftm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiK1Ftl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:49:41 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Nov 2022 21:49:33 PST
Received: from feh.colobox.com (feh.colobox.com [IPv6:2607:f188:0:20::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB406B853;
        Sun, 27 Nov 2022 21:49:33 -0800 (PST)
Received: from [IPV6:2600:6c51:483f:c100:f0c5:c187:a91c:cebb] (unknown [IPv6:2600:6c51:483f:c100:f0c5:c187:a91c:cebb])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by feh.colobox.com (Postfix) with ESMTPSA id 4638B761F26;
        Mon, 28 Nov 2022 05:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=finnie.org; s=mail;
        t=1669613973; bh=zx+ut35DVq/7ZsKQ3zxcMjVSrpDd86XtF0rFa+b4jKU=;
        h=Date:To:Cc:References:Subject:From:In-Reply-To:From;
        b=EalYKxseawCGL2KKSXACWzL65JfNAyfc/wGr4iD6uDP4zebnBfQt9abb9xHEdIR/e
         5Kk3OtCgReYZRLf25pH8UeLWh2WTazgwQU3ByrArWM6ljI6gU2ORS+h2fqSdIHCA//
         Et9fVuAMmF7Rpr2jQLsN69QSGhS/CvsrmvrPiOiQzh/VBLn0ywMeLb8DUzsZAL9lOB
         ZJp7PEc1cfMaLrV8dwkS26AoBvTJWQkXoevJRffCs3AYe2D55OuVuO0l1DpyOrHVdI
         1X0fZ+g2ao66dEvT76LFyCSpo2aSN9jvSclkFitk7sWP9e6NkXLoejL4VnJdTL5il2
         OGus7HH8RM1kQ==
Message-ID: <2e833d1a-e1d1-cf32-3dea-c4ef2995e452@finnie.org>
Date:   Sun, 27 Nov 2022 21:39:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
To:     s.hauer@pengutronix.de
Cc:     alex@appudo.com, da@libre.computer, g0000ga@gmail.com,
        johannes@sipsolutions.net, kernel@pengutronix.de, kvalo@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux@ulli-kroll.de, martin.blumenstingl@googlemail.com,
        neojou@gmail.com, netdev@vger.kernel.org, phhuang@realtek.com,
        pkshih@realtek.com, tony0620emma@gmail.com
References: <20221122145226.4065843-10-s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 09/11] rtw88: Add rtw8822bu chipset support
Content-Language: en-US
From:   Ryan Finnie <ryan@finnie.org>
In-Reply-To: <20221122145226.4065843-10-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at feh
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	{ USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x012e, 0xff, 0xff, 0xff),
> +	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* TP-LINK */

This device is confirmed in the wild as "TP-LINK Archer T3U Nano", and
is a miniaturized version of 0x012d.

(I have not personally tested this patchset, but have verified against
the DKMS tree at https://github.com/cilynx/rtl88x2bu with 0x012e added.)

Thank you,
Ryan Finnie
