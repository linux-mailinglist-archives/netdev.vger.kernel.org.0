Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D55167DC23
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 03:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbjA0CIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 21:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjA0CID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 21:08:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C1F1737;
        Thu, 26 Jan 2023 18:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067C5619F6;
        Fri, 27 Jan 2023 02:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A4DC433D2;
        Fri, 27 Jan 2023 02:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674785265;
        bh=GXhAHAJ3tmgh0CMi6zRRYVrRLrYDPiUKZ0L20iHB/Ww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fZ+Wmxr48VONDYv83ts8E0JCi/HSF8pivdFbhbC/3JOXnyQonDPQaC+hlJ4jfPplK
         1DPygbWgLgluM+j4H2brwCLtaFiTvZ//ESCUl53Tnc3oTmY1tXrPWzVLoHb6SHq3a3
         Yk5jiu6wgM+2zcz9zEF8zPAA6bGOkqqSUoFxj9DOjhajilEirL3OV5znfSsY7uNm8j
         T+SVeL6vH0UnDcnfZUiIc/fdnLAyezotq+5qjlMLaY2tgzd7heE2ya4AFxViW4+IXw
         2NtiwWbtDwMcSOUyZKYbZDOOtu5EOZpIJfUXdjq2Wp62IdDbnR9tq9fLNiKetJfpCv
         +YBoagfDfm31Q==
Date:   Thu, 26 Jan 2023 21:07:44 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.1 0/1] Bluetooth: hci_sync: cancel cmd_timer if
 hci_open failed
Message-ID: <Y9Mx8LCM7ZRoKGGU@sashalap>
References: <20230126133613.815127-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230126133613.815127-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 04:36:12PM +0300, Fedor Pchelkin wrote:
>Syzkaller reports use-after-free in hci_cmd_timeout(). The bug was fixed
>in the following patch and can be cleanly applied to 6.1 stable tree.
>
>Due to some technical rearrangement, the fix for older stable branches
>requires a different patch which I'll send you in another thread.

Queued up, thanks!

-- 
Thanks,
Sasha
