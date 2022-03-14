Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA4D4D8E6A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245155AbiCNUqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243687AbiCNUqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:46:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819EE39B9C;
        Mon, 14 Mar 2022 13:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=AvofpbqmAw1uzBxqUhRN+HUDWul1YdHhSFqMZ7yOrhI=;
        t=1647290713; x=1648500313; b=PFOiRuzQkV/56RGV/PiPZzpRNPGFE0RZGt9RBrxx0K6c8Rl
        5eJTp7Ts1z19/6rvEIl4YRxOe7JbNvRfxxhfp9WIJ8qB00RFASbzRxZKzUSrnHJhZwBJiXRnuYKkG
        wsBXaivux9e9fGnrULKZXj4S20A9P3/j/H2sn2JwRRNm1cVOn6kXCC9YW5R16PuJhxf+C83V59Qyp
        98/xrwK63xjyty579vkrsIR66UHt57/mUePlvBdou+q37lI9AQWVvyJa01CauDS9SZkMV2OeRqO/8
        JtsOEKR+1QyMtNGvcHZ9lF6l/4KqP+WKJ9zxRKahInlltH1qX8dANrIQRblTIi3w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nTrZ1-00DDbU-P4;
        Mon, 14 Mar 2022 21:45:11 +0100
Message-ID: <3e9e10f34215b4d6b3a7361971df3c93d4b25419.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2022-03-11
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Mon, 14 Mar 2022 21:45:11 +0100
In-Reply-To: <20220314134146.20fef5b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
         <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
         <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <87sfrkwg1q.fsf@tynnyri.adurom.net>
         <20220314113738.640ea10b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <6d37b8c3415b88ff6da1b88f0c6dfb649824311c.camel@sipsolutions.net>
         <20220314134146.20fef5b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-14 at 13:41 -0700, Jakub Kicinski wrote:
> 
> Depends on what you mean. The bot currently understands the netdev +
> bpf pw instance so it determines the target tree between those four.

Makes sense, that's what it was written for :)

On the linux-wireless patchwork instance
(https://patchwork.kernel.org/project/linux-wireless/) there are only
two trees now, I think, wireless/main and wireless-next/main. Perhaps
mt76 but maybe we'll just bring those into the fold too. Oh, I guess
Kalle has some ath* trees too, not sure now.

> We'd need to teach it how to handle more trees, which would be a great
> improvement, but requires coding.

Right. Do you have it out in the open somewhere? Maybe we could even
take it and run our own instance somewhere.

> > But I do't know who runs it, how it runs, who's paying for it, etc.
> 
> Yeah... As much as I'd love to give you root on the VM having it under
> the corporate account is the only way I can get it paid for :(

Right.

Anyway, was just thinking out loud I guess.

johannes
