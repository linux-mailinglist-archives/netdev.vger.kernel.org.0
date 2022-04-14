Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE5500BEF
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbiDNLTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbiDNLTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:19:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E09875C3D
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 04:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F907B828FB
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 11:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676B6C385A8;
        Thu, 14 Apr 2022 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649935044;
        bh=sDzu69AvC9LjCN7CXZ4Y7ba1JfQAMt7h7GKMY5dodXc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SIMW1YdiPK//ynoo6HgDfgtlgHbr5+25D4bO3Ecpz+YDcWjwOEnEb1WNLDYk1GFzE
         DEsuXsh/HIEINVUwxNbI7p+FkKKnnYTK0GsWOSNSXGfGu7VF0StVO9DbLDPlCF0ojZ
         pjh/jVbY5uNzLX/TFTSInOReLYZogfrsED49aJ/dXSY+cmQabbpiPX7ljJb4CZm906
         TZB0vTCJxiEnN8akR3d9JgLrrOdwTck4dirbgMVjKVedsTWm6hhIPifq7p22Y/trKL
         QmpfWTWSFBjM7rvnbLmeGZiyS6EwaVR2/FFiUnIq0ZxOewiy/W8cYxnKWGZKRM3UBB
         V7oG6xqARntTg==
Date:   Thu, 14 Apr 2022 13:17:16 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
Subject: Re: [PATCH v5 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <20220414131716.2e2c72ad@kernel.org>
In-Reply-To: <a452ed5f5699447973c237cad1bd6c74bc9e7031.1649780789.git.lorenzo@kernel.org>
References: <cover.1649780789.git.lorenzo@kernel.org>
        <a452ed5f5699447973c237cad1bd6c74bc9e7031.1649780789.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 18:31:58 +0200 Lorenzo Bianconi wrote:
> Introduce page_pool APIs to report stats through ethtool and reduce
> duplicated code in each driver.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
