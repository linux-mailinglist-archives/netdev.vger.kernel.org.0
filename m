Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EAA66B886
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjAPH6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjAPH6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:58:54 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8891E1042C
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 23:58:53 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 3EB06B8B;
        Mon, 16 Jan 2023 08:58:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673855931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1RXXuE+Cag4Wwx8kWm4EEPNjbqIiiiPPUaMdFskU58A=;
        b=R/B4C+ndFbVos65EOm7txgAaQPxsDshaQLYT7hJHYL/onvTIUo95PFvsQR4xsoPXqP6V0J
        7ifdjMcItIo6MIRBBdiBFTfYbxThklKdlADQaJBm1xHpPG8CSXpn/SO9p/h6mymF6nmS+R
        MPu8bvIR9+fEBjDYA6ZfbOqtI0eDQMRkDQ6YrFca8E4jvOGVNZjaCa6iO/IZrZHSZTL2y6
        3B2WnL+lubeYRJAvj1y7YOiYIHk9k4VoReBHPx1GY0Ce49517IukTdvF/3wO61NwofjUZx
        7hWotN7DP6rFXCAg2n7PdjaxOhCNco2uf+8K7tvQ1UxkSkeyhRDSgBIZJEEiOQ==
MIME-Version: 1.0
Date:   Mon, 16 Jan 2023 08:58:51 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] net: mdio: cavium: Remove unneeded simicolons
In-Reply-To: <20230115164203.510615-1-andrew@lunn.ch>
References: <20230115164203.510615-1-andrew@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <039694f9275509d0273baa8fc58fbcfe@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The recent refactoring to split C22 and C45 introduced two unneeded
> semiconons which the kernel test bot reported. Remove them.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 93641ecbaa1f ("net: mdio: cavium: Separate C22 and C45 
> transactions")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Michael Walle <michael@walle.cc>
