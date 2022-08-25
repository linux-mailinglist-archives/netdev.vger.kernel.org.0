Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530975A1685
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 18:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbiHYQRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 12:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbiHYQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 12:17:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC2F7268D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 09:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=We3VIhY6bY7eOl3qI7HJxV8NsFOko0j3XGkfR/3HQuU=; b=dx
        ZmXK4/dnI5PN4V6RTibpLX2hPhfCegmoTY1Vnq7mMhdMu220eeUh5fnJGjuVZzrUCHNytCxhHpMlQ
        EPcAUQzpxBQk2gK+cypeTJavAMUs+H+f0ilrU3nTD+4Xvp9VdnjI4XGCfI+6Y4WwMCVjnrbDyJOpv
        HNTIrAwNbNSAOE0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRFX7-00EaGO-AQ; Thu, 25 Aug 2022 18:16:41 +0200
Date:   Thu, 25 Aug 2022 18:16:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and
 802.3
Message-ID: <YwegaWH6yL2RHW+6@lunn.ch>
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220825090242.12848-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:02:39AM +0200, Íñigo Huguet wrote:
> Most recent cards (8000 series and newer) had enough hardware support
> for this, but it was not enabled in the driver. The transmission of PTP
> packets over these protocols was already added in commit bd4a2697e5e2
> ("sfc: use hardware tx timestamps for more than PTP"), but receiving
> them was already unsupported so synchronization didn't happen.

You don't appear to Cc: the PTP maintainer.

    Andrew
