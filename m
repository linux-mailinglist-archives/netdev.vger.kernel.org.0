Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECB6E16C9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDMV6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDMV6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:58:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA3C19D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lWCc82hrpX0xmO3exXUwOqLJ9pdTepxCLxZ1SjTygUk=; b=G5vnQ5FNNLpYvuP9fqzzMUSfNn
        nQuC9Catyi6d4WVpPfJgSQd+yhwDnkNVSGdM7njr27R7Eknxg/1CMLe/iILGf64uVzPJuun/2jP//
        TroIeYMYCbss31JVziKakLb1j3QXcTqsaZ5JA6k18ZYkLWbkLvKLMmLx6K7XhV1VCazo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pn4xg-00AEHk-0m; Thu, 13 Apr 2023 23:58:36 +0200
Date:   Thu, 13 Apr 2023 23:58:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting
 RSS contexts
Message-ID: <a628b861-47a9-44d2-a717-5268dc5b47f6@lunn.ch>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
 <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
 <69612358-2003-677a-80a2-5971dc026646@gmail.com>
 <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
 <3623a7f3-6f90-8570-5b9a-10ff56cc04e5@gmail.com>
 <20230412190650.70baee3e@kernel.org>
 <485ebfeb-61d7-7636-80af-50b6a008b6dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485ebfeb-61d7-7636-80af-50b6a008b6dc@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> (Idk, maybe sfc is just uniquely complex and messy.  It wouldn't be
>  the first time.)

Hi Ed

Have you looked at other drivers? It would be bad to design an API
around a messy driver. Maybe this is an opportunity to learn from
other drivers and come up with something cleaner for SFC?

      Andrew
