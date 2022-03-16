Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDA04DB02B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355949AbiCPM5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbiCPM5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:57:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4F62A12;
        Wed, 16 Mar 2022 05:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LmmB2Erj1jpfGkRLnpwe7cf7WboJOCv0J54etJDojOY=; b=Td4FigwoT7Iu2FICJhxFKA1fQU
        gfzRAkQ2wpTv4eW9I6v1ohLxY3+zdr8TUZW3evkk81VG7F2ATov8ON8y1ZcPBO5d0rjJgAX7OplXU
        ZuHXJ9cyBXv2kzDIOXIWNq7DuuE2IgGb1Y/fm3hmcFNbLFBKhst3ltpf5Nwkoka6+4d4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUTCR-00BEEh-FP; Wed, 16 Mar 2022 13:56:23 +0100
Date:   Wed, 16 Mar 2022 13:56:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     kuba@kernel.org, sebastian.hesselbarth@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH V2] net: mv643xx_eth: undo some opreations in
 mv643xx_eth_probe
Message-ID: <YjHed0u9X0bVd6fL@lunn.ch>
References: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316012444.2126070-1-chi.minghao@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 01:24:44AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Cannot directly return platform_get_irq return irq, there
> are operations that need to be undone.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
