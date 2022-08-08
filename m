Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA6658D089
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 01:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbiHHXqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 19:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiHHXqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 19:46:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A05FC1;
        Mon,  8 Aug 2022 16:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E626561012;
        Mon,  8 Aug 2022 23:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C48CC433C1;
        Mon,  8 Aug 2022 23:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660002375;
        bh=pVwwRQ3k5NUB1FtWd6Kz5rdw9BWFAVlpkBpTB58ZFGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XkkawPqeFCQkeEtFCBG5c+QnOUv9fGgQDRmpryyJ0NCpn9zlrxrt1gBSC4wpd6ViD
         zpGWPcW08QP72coiyem8sMJ/IFk3oyeppZ6VGbkSkAgMWKMRw1WzfQKTRDuX9IyLXo
         BRoho6V8oBynJH47YjYyonkG1hzoCdzVMLleYBy2zCPFl7tMVoDuZPOEYqCTSb7RX1
         DHDcQKxPsc/wWsyruId84Izx3kmj/rA8MFBklt2uOKqrVKoda/ME1RbytXCGDbPDJN
         DlMzcqnpKys58CaB0TLvOa5vPiABK27aHH/omtnEKbZauLbbLQWar2RnQCzFML7oZa
         l9BYmUGlHQ3sQ==
Date:   Mon, 8 Aug 2022 16:46:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: pull request: bluetooth 2022-08-05
Message-ID: <20220808164614.3b4b5a25@kernel.org>
In-Reply-To: <CABBYNZJXdt_aL2SOH_Eu9PDaLhHksTRJDBPKSDitXKURPqG-7w@mail.gmail.com>
References: <20220805232834.4024091-1-luiz.dentz@gmail.com>
        <20220805174724.12fcb86a@kernel.org>
        <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
        <20220808143011.7136f07a@kernel.org>
        <CABBYNZKmuUpmUChz+tixFCOE_pUeaJq0Sbqkvjy54zd9H=GB4A@mail.gmail.com>
        <CABBYNZJXdt_aL2SOH_Eu9PDaLhHksTRJDBPKSDitXKURPqG-7w@mail.gmail.com>
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

On Mon, 8 Aug 2022 14:51:00 -0700 Luiz Augusto von Dentz wrote:
> Is there a script or something which can be used to verify the Fix
> tags? Or you can actually tell me what are the hashes that appear not
> to be on net.

Yes:

https://raw.githubusercontent.com/gregkh/gregkh-linux/master/work/verify_fixes.sh
