Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130256BF7B0
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCRESV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:18:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D438442F8
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C12DEB80DCA
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445BDC433D2;
        Sat, 18 Mar 2023 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679113095;
        bh=tjDl0AmGEvTNIdsLZfMPJz9vcHrQYazZL00RbxuQk5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U1rtr144+NonV1jZVoDuUrCWhR00sp5d+oZz1zWCpR9oF8ujphQQqyajybjgA8Wel
         4DJmlrg9+Nhb0cfW10cEzo+aeici9zAg2fMmVdmtmwyuDN5xgL1OR6Mg3BNkHBYEeb
         czVusvTmnntPdp+OlebSrTT8mvmtnCM4TQnneaPIftafT32/0gaeWRJDGOYE3o3MZ1
         6ddYeNE60YSVbNsKn/VKIr9FgkjLxJrqrDIa2L6T8dVBbSkoseg9T5YAGL5KyAbk2V
         SBGkVFOCv6Ov93ywHCE5RC/P/FKwENdbUYq4VWMJUjxz8z9nGy3kpL+xZsyGXszulQ
         w130KgjiaeMEA==
Date:   Fri, 17 Mar 2023 21:18:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 1/4] ynl: support be16 in schemas
Message-ID: <20230317211814.0092b714@kernel.org>
In-Reply-To: <20230318002340.1306356-2-sdf@google.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 17:23:37 -0700 Stanislav Fomichev wrote:
> ynl: support be16 in schemas

https://docs.kernel.org/next/userspace-api/netlink/specs.html#byte-order

byte-order: big-endian

Looks like it's slightly supported in ynl-gen-c but indeed the CLI 
lib doesn't have the parsing, yet.
