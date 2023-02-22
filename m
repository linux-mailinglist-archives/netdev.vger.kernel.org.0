Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135D969FEAB
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjBVWpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBVWpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:45:09 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F022F10F4;
        Wed, 22 Feb 2023 14:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Reply-To:Content-ID:Content-Description;
        bh=9rb+kGPcrAD1VHbJnFkQ6wqykf5BJOE05IV8W1ATD8Y=; b=Gf1ZBTpU6d/YTGZrOomXNuzx5a
        cEWhjZT0pyw3KvkQGMtAdZEJywO8Fh47i2cOJrFax2Xot/gY9tWK+D25RKfLsxN8cIFVHMWKjuXef
        9U+PGgMBs/YHC6Tnc7RHV7nM2ji/3oM4rloCvbC0hB/5exWkgC95S/7swAlg2D6zl7PUi4eu/pt5r
        Go3S/OVsFi2WLzGs3LBPoM63RQzOWJinfN3KH4K7u5gxMnedzDhU9QrdaUQuhTzlC19YKXH7Jee1d
        mPScDILcpwXwIiQEuf4rEbLRvvFhcnOsN/E6S8o7RcUklSjjAMEPmK9yJzFSouRjv0Mmh3TgLsl/f
        pfm8Ki9w==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pUxrA-008z2d-Bi; Wed, 22 Feb 2023 22:45:00 +0000
Message-ID: <b8dd4590-92d5-efcb-d8cf-d15e0e1f9547@debian.org>
Date:   Wed, 22 Feb 2023 23:44:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v5 0/2] Bluetooth: btrtl: add support for the RTL8723CS
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230212124153.2415-1-bage@debian.org>
Content-Language: de-DE-frami
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <20230212124153.2415-1-bage@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Debian-User: bage
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 12.02.23 um 13:41 schrieb Bastian Germann:
> v1 of this series was sent in July 2020 by Vasily Khoruzhick.
> I have tested it to work on the Pinebook.
> 
> Changelog:
> v2:
>     * Rebase
>     * Add uart-has-rtscts to device tree as requested by reviewer
> v3:
>     * Drop the device tree as it was split out and is already integrated.
>     * Rename the quirk as requested by reviewer Marcel Holtmann
> v4:
>     * Use skb_pull_data as requested by reviewer Luiz Augusto von Dentz
> v5:
>     * Make use of skb_pull_data's length check

I have addressed every comment.
Would you please consider integrating this 2.5 years old series?
