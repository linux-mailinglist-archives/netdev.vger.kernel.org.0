Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07984FBF05
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347267AbiDKO2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347183AbiDKO2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:28:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34FC39155
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XcT6FzquqopacrOnV/feWmHMvMP0g4Ksy2bKFWWg++0=; b=ho+F24ab6oJ0sUlIm5AO6i26Zx
        nttrd9FTcbucOtqiEzOD3guvDbeGshUlogzlkRd2UONa71XJQkudYiROd0s4MD69FcKepJLvMOqcP
        s/BDP6Uf6/T/Ur5JDAUDk4WOOyKtO46iXyfv2oJ7DASPh9Qlhd9t0ln38DN2UwEpuWMc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nduzK-00FH22-Ni; Mon, 11 Apr 2022 16:25:54 +0200
Date:   Mon, 11 Apr 2022 16:25:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Schild, Henning" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information
Message-ID: <YlQ6cm/BYbrWejW4@lunn.ch>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
 <YlQtII8G2NE7ftsY@lunn.ch>
 <VI1PR10MB24463A87DC9BED025D377CD8ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR10MB24463A87DC9BED025D377CD8ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 02:17:44PM +0000, Geva, Erez wrote:
> The Tag driver code in not by me.
> So I can not publish it, only the owner may.

If the code is licensed GPL, and you can fulfil the requirements of
adding a Signed-off-by: you can submit it.

However until there is a user of this, sorry, this patch will not be
accepted.

     Andrew
