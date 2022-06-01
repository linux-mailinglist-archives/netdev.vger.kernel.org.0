Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABC353A282
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiFAK2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351930AbiFAK2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:28:13 -0400
X-Greylist: delayed 325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jun 2022 03:28:10 PDT
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AAB15715
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:28:10 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1nwLUv-006buI-Fi; Wed, 01 Jun 2022 12:22:41 +0200
Date:   Wed, 1 Jun 2022 12:22:41 +0200
From:   David Lamparter <equinox@diac24.net>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net 0/3] dpaa2-eth: software TSO fixes
Message-ID: <Ypc98aY9OkP/8VfI@eidolon.nox.tf>
References: <20220522125251.444477-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220522125251.444477-1-ioana.ciornei@nxp.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 22, 2022 at 03:52:48PM +0300, Ioana Ciornei wrote:
> This patch fixes the software TSO feature in dpaa2-eth.

Could I bug you to get these thrown into -stable?  5.18.1 is currently
unusable on LX2k (with IOMMU enabled).

Thanks,
David

(Apologies if it's already underway.)
