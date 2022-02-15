Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FBC4B644C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 08:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiBOHZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 02:25:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiBOHZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 02:25:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C2FF1EBD;
        Mon, 14 Feb 2022 23:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1na6bMT5LjyKnWmZxmOKshc4Jv/0ipnOPh9rGFlZkyg=; b=3tqerZdTtWW2MvD6HJpNoRfif2
        yJXqbzFsDJ+40nrKHhdoJ2lhAMiU5rV5BdDAA+80v/UV9TiyYPtDQSderkyxyh3WvTY9IYZ/A+UqP
        i0t6imr3fYxwDGKscBvV9QwO7B/kiY4tFhKi0WxSsqMnuEEL7W2SUIl2JKQLNs3RcQZT6pC0mSfv6
        R38w5gS+xTYBTQKuD7P7kJdk++hnXQRyXaXrhjcUIl0D6kvPrGkcPfoNbViaLHAPIcbgiBe4GKloU
        cnvmXS86fZ9Pi+vQ79tf/r102nd3C1fTuXqH7VdwA5KYnfeOaK5Tkx0v+k/5zLjY5e0dgepETgN6h
        9lK9HAqw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJsDZ-001AnB-JN; Tue, 15 Feb 2022 07:25:45 +0000
Date:   Mon, 14 Feb 2022 23:25:45 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     davidcomponentone@gmail.com
Cc:     jirislaby@kernel.org, mickflemm@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH v2] ath5k: use swap() to make code cleaner
Message-ID: <YgtVeWr2stdv01Gh@bombadil.infradead.org>
References: <b6931732c22b074413e63151b93cfcf3f70fcaa5.1644891799.git.yang.guang5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6931732c22b074413e63151b93cfcf3f70fcaa5.1644891799.git.yang.guang5@zte.com.cn>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 10:31:34AM +0800, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---

Sorry I don't trust your code as you submitted an incorrect patch last
time. So unless we get a Tested-by that there is no regression I can't
say this is correct. Please fix Zeal Robot, or better yet, open source
it for peer review.

  Luis
