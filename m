Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C51F6B36A7
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 07:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjCJGaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 01:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCJG37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 01:29:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139B9DB4B5
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 22:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D55360CBB
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 06:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC00C433D2;
        Fri, 10 Mar 2023 06:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678429798;
        bh=UhltkHuyDvxervY2+QhQbU7PCwKlmRpG61amyoQI9CE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T4gNGvH+eOZvR7PNrm9Ebb/Cc+rYuDKp/NskUU7sl89xmTu7g5iVfPq7LCVU7c8jI
         7POp33J6HULVeIYIBBM9rGs44BIyYqj6dCmbxHCeL7Q2ttiOFXjxRKXPiPooRLWnAT
         /xrD+YkcCvjS+UuXI7yUSBFzeocP/4O4pXtWHSYddPiKU6GXHRUr+8XV08Kqu6xiwx
         pkLYV8IfavSjHk2CvtiISWnhqsZThWrgEPaZjDlF9g4w1yoHRIEnQQ1VzbcOhH+f7V
         zb2VFrAInOjs2bycHpD7r7wQcVtyoeuBg/MGrla5a5crAAjyhYM5fXU8lZ6jR4Jkiq
         cHBpnFDNKqT/A==
Date:   Thu, 9 Mar 2023 22:29:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net-next v4] net: dsa: realtek: rtl8365mb: add
 change_mtu
Message-ID: <20230309222956.112261a1@kernel.org>
In-Reply-To: <CAJq09z6ZG4bw_fiLM_-1NfzyE6LDnko1uehzSWCN9RLu_48Ffg@mail.gmail.com>
References: <20230307210245.542-1-luizluca@gmail.com>
        <ZAh5ocHELAK9PSux@corigine.com>
        <CAJq09z7U75Qe_oW3vbNmG=QaKFQW_zuFyNqjg0HAPPHh3t71Qg@mail.gmail.com>
        <20230308224529.10674df1@kernel.org>
        <CAJq09z6ZG4bw_fiLM_-1NfzyE6LDnko1uehzSWCN9RLu_48Ffg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 23:55:46 -0300 Luiz Angelo Daros de Luca wrote:
> Let me know if I'm still not clear or missed some important topic.

LGTM, thanks!
