Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9106F678DAC
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 02:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjAXBps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 20:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjAXBpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 20:45:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57C13608D;
        Mon, 23 Jan 2023 17:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xXiBpE0rF4/8Aee562/mORcqfLHwO14uyCan0/XcDH8=; b=jZ6EWiWSPMTJZrL+n/VfBDNgWK
        MVfw6ZE3EnmVOgpz/BRyljvr0mqomn81YZz77l5vlmkEHnNjCUQjVj8HL/zhTP03HxGQwGiYbfSAP
        fdKvUG+rWsJjzp9a+qidSGj6fCD6Z/thKlj8kXQaK1X+V8WFmWYJMKrT8W7e6tpmmFbM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK8NU-002y5x-O4; Tue, 24 Jan 2023 02:45:36 +0100
Date:   Tue, 24 Jan 2023 02:45:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, yangyingliang@huawei.com
Subject: Re: [net] net: ethernet: adi: adin1110: Fix multicast offloading
Message-ID: <Y884QEYIlZxVlmFc@lunn.ch>
References: <20230120090846.18172-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120090846.18172-1-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:08:46AM +0200, Alexandru Tachici wrote:
> Driver marked broadcast/multicast frames as offloaded incorrectly.
> Mark them as offloaded only when HW offloading has been enabled.
> This should happen only for ADIN2111 when both ports are bridged
> by the software.
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
