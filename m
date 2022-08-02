Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCDB587D32
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiHBNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiHBNfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:35:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD20F1D0DB;
        Tue,  2 Aug 2022 06:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Cz/Gg0H1PZdT1eyaGmiaosYjZaEC4JeevVqD0EdTBJE=; b=bTUa0js+rIq/jNC+RK+013CKTx
        kbOcu1y6p9Nzs+IHhLq2VeDvoykvUrvlOH0YGmnLSMLr97iSwPzpy77x42eFem/X72ZB3axLpzqiY
        cs56hQmaWhgn/5g0hTSHT9D/nOTZZXWX5PCM9UJyLLiWtisBF35lzwI+qHrAD2n/+HWw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oIs3j-00CGDa-Aq; Tue, 02 Aug 2022 15:35:43 +0200
Date:   Tue, 2 Aug 2022 15:35:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] net: ethernet: ti:using the
 pm_runtime_resume_and_get  to simplify the code Using
 pm_runtime_resume_and_get() to instade of  pm_runtime_get_sync and
 pm_runtime_put_noidle.
Message-ID: <YukoL8Y5UZq4Goma@lunn.ch>
References: <20220802074737.1648723-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802074737.1648723-1-ye.xingchen@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 07:47:37AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>

It seems like 1/2 your subject line should be in the body of the patch
as the commit message.

   Andrew
