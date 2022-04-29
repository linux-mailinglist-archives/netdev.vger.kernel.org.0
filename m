Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66134514DBB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377641AbiD2OpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378157AbiD2Oo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52395AEDE;
        Fri, 29 Apr 2022 07:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B04D861A09;
        Fri, 29 Apr 2022 14:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBDCC385A7;
        Fri, 29 Apr 2022 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651243260;
        bh=zbW9iUV/RG0Ob9qAu90IBbElC2QsUzjzzLanYd3CW2M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=sAWtZ+/ks6cyJgabSY5Jq8dYVXgNO022Tjz9BAzzocHhoo6lSN9DatoyKFxMY0CFy
         940ZJUR6IM7zhrgsB8KjzwMTs0alKb5kHwA3/67r6bnt0Ceon93VN1dWKlQYUR4DTy
         g7s5V47TBPbcnngPaF4bXMvoDkfI1ulc0j18spu16qR8hSnDGDlXUx1AcC1USmufNB
         Tt/avoZjV2BmF9va7ZTWfHLXOLaif7cr0vu32M9ufiwFSwzr8NoLkBRL+NwIlPts4R
         kSLxblpGiruzhzI3KwcMz98lGkqpsjvSUnbTTDlW3WqQq1eJXgAGPnr4J3A8Oeh7sC
         F2zLO+tojc9Rw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jouni Malinen <j@w1.fi>,
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [RFC v2 38/39] wireless: add HAS_IOPORT dependencies
References: <20220429135108.2781579-1-schnelle@linux.ibm.com>
        <20220429135108.2781579-70-schnelle@linux.ibm.com>
Date:   Fri, 29 Apr 2022 17:40:53 +0300
In-Reply-To: <20220429135108.2781579-70-schnelle@linux.ibm.com> (Niklas
        Schnelle's message of "Fri, 29 Apr 2022 15:51:07 +0200")
Message-ID: <87zgk4c5qi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niklas Schnelle <schnelle@linux.ibm.com> writes:

> In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers using them.
>
> Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

I assume this will go via some other tree than wireless-next:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
