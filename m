Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AC05BD6A3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiISVwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiISVwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E9043608
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 14:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD9F3B81A6A
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 21:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E655C433C1;
        Mon, 19 Sep 2022 21:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663624335;
        bh=voQJTyzoC/3PzDgIMHhnzw24jCQzAjuuIiYLI8hvkN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g4PGcd27JHq/+iMC014YiPInIf47zAM4cwXe1QL6lsM3BEmLdde16ZO46NUDNtykg
         MwZdsk1eJWKJyz01Bp/eE5+lpvXR/lN8u7fhbS9JJ5sDF/99EryNQWWnXU5DwaxidV
         oUWPRU97nJ8CRCSH4Z6R8szxUjbyxF0EpKOsCnDEJMxoEQFK+vjSjf8fWUKR2oPUST
         2AJsP0Uik8xqKylh1YhgVq/71ms4Gt8c9ZTk6xaCqPX+KzB7bwy1Eo3SPEYPniOuyo
         n+avvZSl5eWMIwPAgEQ4p1VSXDoZEbjnPqrnL9CtSvpcIQ2kUVmXtz1AhfUlqQ9boQ
         icdokA1+/jxZg==
Date:   Mon, 19 Sep 2022 14:52:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net: dsa: microchip: remove the unneeded
 result variable
 -------------------------------------------------------------------------
Message-ID: <20220919145214.366b7cd4@kernel.org>
In-Reply-To: <20220912075045.17060-1-xu.panda@zte.com.cn>
References: <20220912075045.17060-1-xu.panda@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Sep 2022 07:50:46 +0000 cgel.zte@gmail.com wrote:
> Subject: [PATCH linux-next] net: dsa: microchip: remove the unneeded result variable -------------------------------------------------------------------------
> Date: Mon, 12 Sep 2022 07:50:46 +0000

> Return the value ksz_get_xmii() directly instead of storing it in
> another redundant variable.

Does not apply either, also the subject is off.
