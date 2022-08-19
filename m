Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24B0599DA5
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiHSOdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349361AbiHSOdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:33:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730BDEA88D;
        Fri, 19 Aug 2022 07:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D57E5CE2689;
        Fri, 19 Aug 2022 14:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EE2C433C1;
        Fri, 19 Aug 2022 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660919578;
        bh=83usqMHzDR0vwJ2pSameC8InNk72mpY0/ge0yNAMdiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TCigOBAN7hFXjkVlwHgvVyNJuuvuOUGGVFoX25zDtVgYnTMnj/cFZjsT3ToegKn1i
         qbpCrW89O2iK9TWnIjHmMIoL/qe4zoLheiEBpnlBYNWWhR0EqzB75MhuRpRgihOUrz
         3Ze6qNiy/3X1d0GDNdwT1Uec/txeuckhQ3gDUidY=
Date:   Fri, 19 Aug 2022 16:32:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Stanislav Goriainov <goriainov@ispras.ru>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <Yv+fEteaeS0o2965@kroah.com>
References: <20220818141401.4971-1-goriainov@ispras.ru>
 <20220818141401.4971-2-goriainov@ispras.ru>
 <Yv9yV9SpKQwm7N3z@kroah.com>
 <Yv+Vvmia1CBnU6Jq@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv+Vvmia1CBnU6Jq@casper.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 02:53:02PM +0100, Matthew Wilcox wrote:
> On Fri, Aug 19, 2022 at 01:21:59PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 18, 2022 at 05:14:01PM +0300, Stanislav Goriainov wrote:
> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > 
> > > commit 3403fb9adea5f5d8f9337d77ba1b31e6536ac7f1 upstream.
> > 
> > This is not a commit id in Linus's tree that I can find anywhere :(
> 
> I see it as 3cbf7530a163, fwiw.

I'll wait for a resend, as obviously something went wrong on the
sender's side...
