Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2478F5F4593
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 16:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJDOgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJDOgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 10:36:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B92461707;
        Tue,  4 Oct 2022 07:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC242B81AFE;
        Tue,  4 Oct 2022 14:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6151BC433C1;
        Tue,  4 Oct 2022 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664894180;
        bh=hLEJhKoBiElbTOGbECQsLsEGngfhaQZtpxlkMNWAW3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zd1z14pChTEje9nae5gkAqf8H3zesLKO/43wGvAIZnIwFkAJ1NWa2lfYxF5+KnOJN
         snHfo7JEDjsTbOtVwhUpLkrRky/uTZm4B67uZiIo7PFzmZDWn4hTpE3P4vAn3Av0Yd
         mQW8FuMkccnHrmn6azuMdkbwjznyjvExUMrTU8PHbaiL9hlig4xDg4S6I48J8ZpYlg
         J/FjH1SPQb5AhD5mnNAKrG0u8EPt6OGUnQJSmduemjstfwGnGSeXL/ohJ+1H3R4a9h
         zd7EoKQK6Qb66QrAR11DGevYcSZZSyBaqNxL2+7lhX9zwy8nzLj0+A9gvdd3Y7d7tg
         X2SdhigfKCmYQ==
Date:   Tue, 4 Oct 2022 07:36:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Yang <mmyangfl@gmail.com>, Paolo Abeni <pabeni@redhat.com>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] net: mv643xx_eth: support MII/GMII/RGMII modes for
 Kirkwood
Message-ID: <20221004073619.49fd84be@kernel.org>
In-Reply-To: <20221003171320.23201c56@kernel.org>
References: <202210020108.UlXaYP3c-lkp@intel.com>
        <20221001174524.2007912-1-mmyangfl@gmail.com>
        <20221003171320.23201c56@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 17:13:20 -0700 Jakub Kicinski wrote:
> I don't see any of the versions before v5, you should restart numbering
> when you post something to the list for the first time.

Paolo pointed out to me that there were previous versions..
Apologies for the confusion, I must have deleted them locally
because they were all posted in a thread and that messes up
my review queue ordering.
