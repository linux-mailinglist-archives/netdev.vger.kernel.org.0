Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E845F187C
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiJABrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiJABrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:47:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C7015516F
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D47EB82AF8
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 01:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC844C433D6;
        Sat,  1 Oct 2022 01:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664588857;
        bh=kmwQy32tyNsJncZeImDBSEB8+CxoTA0yqYcm+XK64y8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NU6Ctll2R2IgErb0RISCk7vn7YqnTYnjhYwBpOtH9wfjgoh1A5IpS+qediQveksa7
         jgoVUP7RS5Zk8AbvSfrqsgAfnbT0kP1PXLRlTyfDsukUSt8Eq9UcLNNud5V/jBGXxU
         9Yx4qPCY/UQZC5SMC/X/Zo7o+j88fbSxxezhogOG3E9eWulGhknO1whmzACtooDgtm
         KcXXLphLk3Rhgm9YC5kNblnkANnCnw+k3Nhhi8KriWOU3cxrsM/7cTp9moASz3pQh1
         qxkJmPKEyt3UF9SFPkE7UHJjvLATAes/f+JYqvz6g01CwRZi+9CPnxw6v0lXF8TC7E
         nbT8nvbWy5ItA==
Date:   Fri, 30 Sep 2022 18:47:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next v2 0/5] nfp: support FEC mode reporting and
 auto-neg
Message-ID: <20220930184735.62aa0781@kernel.org>
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 10:58:27 +0200 Simon Horman wrote:
> this series adds support for the following features to the nfp driver:
> 
> * Patch 1/5: Support active FEC mode
> * Patch 2/5: Don't halt driver on non-fatal error when interacting with fw
> * Patch 3/5: Treat port independence as a firmware rather than port property
> * Patch 4/5: Support link auto negotiation
> * Patch 5/5: Support restart of link auto negotiation

Looks better, thanks for the changes.

BTW shouldn't the sp_indiff symbol be prefixed by _pf%u ?
That's not really introduced by this series tho.
