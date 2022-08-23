Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C4C59CE25
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbiHWB4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbiHWB4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:56:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0255AA05
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67A9BB81A82
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012FDC433C1;
        Tue, 23 Aug 2022 01:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661219770;
        bh=XgdWCJT9QoyDGiakuMm5j7t7TCbk5+9fRtBXLlEhvf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=osNqpFYHkd6jzHr0+LX+Coje1CY0sV5fxYv5bGW/rUFR7G1j4utSRA/RoNjn0p8sO
         CYET/BOfCkyVgJT5AhngvFqAhZ+4poxDz2wesj21lSqWqYwzArZ3geF7j9uDCdNSMv
         RN0KJRAfCK7OIXYl1RjV76eC8aCLbAaixOQnAqaST/pM8p2mIcVhCE8nxA3ZVpCnXK
         41zgdin9oyNmHezEY4A9n4eJS/JqULrUF+AFwZz7v8i6pwchaMR3CeZ7ay85OO28ea
         MYhprfWAAMZLEqqueIARNyAtsnxJA27xdVzHkNV7GnpwQqnb96e3V0FOp2kzHasTVv
         TDdqRChq9Izjg==
Date:   Mon, 22 Aug 2022 18:56:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harsh Modi <harshmodi@google.com>
Cc:     netdev@vger.kernel.org, sdf@google.com
Subject: Re: [PATCH] br_netfilter: Drop dst references before setting.
Message-ID: <20220822185609.1d34f75d@kernel.org>
In-Reply-To: <20220819183451.410855-1-harshmodi@google.com>
References: <20220819183451.410855-1-harshmodi@google.com>
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

On Fri, 19 Aug 2022 11:34:51 -0700 Harsh Modi wrote:
> It is possible that there is already a dst allocated. If it is not
> released, it will be leaked. This is similar to what is done in
> bpf_set_tunnel_key().

Please repost with a Fixes tag and appropriate folks added to the CC
(scripts/get_maintainer).
