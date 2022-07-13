Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDDA572C0E
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiGMDy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiGMDyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:54:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABE4D863E;
        Tue, 12 Jul 2022 20:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC1B1619D6;
        Wed, 13 Jul 2022 03:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AA0C3411E;
        Wed, 13 Jul 2022 03:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657684492;
        bh=gnBy6Ab9XgDFL3xiP37PoQYDOtaIzWpH+OVMx4jzRSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QZslAdHnOE8HFNa5YFPD3ChkV2qkUICCDW3HHhdmbSwBVulxsyWKaExEPGH33CHqA
         mGZU6oRGNalKCX8rGrHIhnDG9DIeJ+rJzFUvu1GrERQdM2mS1C430fYoSE7lQaNyKp
         xSEASO/SDE79EUBZHz++t8I+h4hPsx4CANsRJgwwRsCyF9M3D/4C4WcGnGFbDnSac5
         6lGyotKEFkwySe/C4kdlMfeSFy7ippMs3OzpCuTeKoMiPOWOH0kp6V6IGAk2ZRHkcv
         1NVXO1OVbSeqra3t9sUGE4bDYHyRonvIBkAEAvdh2iKevkUo/wsvlluY9grtDxyZWH
         IPg89h2zQD8Vw==
Date:   Tue, 12 Jul 2022 20:54:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net/smc: Allow virtually contiguous
 sndbufs or RMBs for SMC-R
Message-ID: <20220712205442.22a29fcd@kernel.org>
In-Reply-To: <1657626690-60367-6-git-send-email-guwen@linux.alibaba.com>
References: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
        <1657626690-60367-6-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 19:51:29 +0800 Wen Gu wrote:
> net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R

This one does not build cleanly on 32bit.
