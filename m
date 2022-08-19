Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81206599AE0
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348556AbiHSLWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348516AbiHSLWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:22:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C467201B9;
        Fri, 19 Aug 2022 04:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31856B8273F;
        Fri, 19 Aug 2022 11:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A64DC433D6;
        Fri, 19 Aug 2022 11:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660908122;
        bh=wFDubVf/wgkcshdJ9OLiWZ6qElam43aK3cgHdvuWNAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gGtyD77zpI+2gALvhz+BpLM2ONNMyz3IFowUy9ns7reG55xWAlb0wSno69czlwibo
         27ri0n4+HepOSxRd0POUYGDAnEFN6gf98pqXa2AP6ynwgRrKZJzRk7xP2VcPGl1YFi
         lY1VCOc2pXxLO5PVVmKv5wi9cXcyZfpHfYborrro=
Date:   Fri, 19 Aug 2022 13:21:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanislav Goriainov <goriainov@ispras.ru>
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <Yv9yV9SpKQwm7N3z@kroah.com>
References: <20220818141401.4971-1-goriainov@ispras.ru>
 <20220818141401.4971-2-goriainov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818141401.4971-2-goriainov@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 05:14:01PM +0300, Stanislav Goriainov wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> commit 3403fb9adea5f5d8f9337d77ba1b31e6536ac7f1 upstream.

This is not a commit id in Linus's tree that I can find anywhere :(

