Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4A65539A
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 19:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiLWSVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 13:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLWSVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 13:21:16 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0B52DD8;
        Fri, 23 Dec 2022 10:21:15 -0800 (PST)
Date:   Fri, 23 Dec 2022 13:21:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mricon.com; s=key1;
        t=1671819673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AiPnTZHpkNIgqMHKjSOUpL+Tv5lpBZfS9s5X+H0WbTk=;
        b=FstcllS6KeXq+cKuBxiHV/qljoZ/n9jPofrVzTGVVqncKStUXpQV1GipCHw9Lm/dAa7BNT
        c0dXwpiuE5tKThz+tdL4bIgAqz5NAnhZSX7ANfF1D/62Ekl4pXpsSmWxZVHkbf4zE40lBl
        OCbjgRm3qOlUf34UO9spf0b+zmxdnhA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Konstantin Ryabitsev <icon@mricon.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Schleusener <Jens.Schleusener@fossies.org>,
        Konstantin Ryabitsev <mricon@kernel.org>
Subject: Re: [PATCH] rtl8723ae: fix obvious spelling error tyep->type
Message-ID: <20221223182109.nf2e2mya34tk5asx@ubuntu2204>
References: <20221222-rtl8723ae-typo-fix-v1-1-848434b179c7@mricon.com>
 <ac905b7e70094edcb3bcefe4b901428a@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac905b7e70094edcb3bcefe4b901428a@realtek.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 01:57:05AM +0000, Ping-Ke Shih wrote:
> > Subject: [PATCH] rtl8723ae: fix obvious spelling error tyep->type
> 
> subject prefix should be "wifi: rtlwifi: rtl8723ae: ..."

Updated in v2, thank you!

-Konstantin
