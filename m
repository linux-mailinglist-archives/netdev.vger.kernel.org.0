Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34145599D2F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349487AbiHSNxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349017AbiHSNxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:53:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ADFFF8C4;
        Fri, 19 Aug 2022 06:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1nihXeNF4yhL+Lbd+0Ku/roqWAUs6vjfLsjgb2DxyRY=; b=uQRf46hQ8vQhaUKfvziSUPTL10
        3SgfRL8UegvhE0U2LQK71MOalcwJKgovHrBunP7jaxC/uQqUg/gIHlzeVCqJTquQTlYcQ5EydfbLF
        rL6Wd+u8s8u8kBCCIHkVzScQ8cSs2UeL/wqfFMeYdCQS1QGPh5U+DWc00YIsVdwfvwVR3tuqqK5E0
        Q8U9qnRfrhJadZHVhIz0gPg54u1F7VTG3QJhkFTCGjaz5pQy1QTM+ATZcPJ8l6we/FHkx6+Nlrs1v
        GOJCC5QFbFdWOOXRBC1d53Yqui9NAsrFsq3EAIfoLe0hVU04c8DPuvqR81lNzCwswKO2/cw0X5M6e
        ZDeerCLA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oP2Qo-00BCLU-89; Fri, 19 Aug 2022 13:53:02 +0000
Date:   Fri, 19 Aug 2022 14:53:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stanislav Goriainov <goriainov@ispras.ru>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <Yv+Vvmia1CBnU6Jq@casper.infradead.org>
References: <20220818141401.4971-1-goriainov@ispras.ru>
 <20220818141401.4971-2-goriainov@ispras.ru>
 <Yv9yV9SpKQwm7N3z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv9yV9SpKQwm7N3z@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 01:21:59PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 18, 2022 at 05:14:01PM +0300, Stanislav Goriainov wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > commit 3403fb9adea5f5d8f9337d77ba1b31e6536ac7f1 upstream.
> 
> This is not a commit id in Linus's tree that I can find anywhere :(

I see it as 3cbf7530a163, fwiw.
