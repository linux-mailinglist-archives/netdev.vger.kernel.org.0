Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A6D5342CF
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 20:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiEYSSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 14:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240160AbiEYSSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 14:18:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6CAABF67
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 11:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4YSZFXBwmNN7RuB2i/Xu7hhpzRE4CFBGyrftMkYAjzo=; b=Pc08/OaP+IHvJR92mIs+SVho7g
        R0I7/dcNURjZAoG8vWMT+ayTcIPOP2+O9Nv3A5LM2YcOLv/HGaZM7If+olEceEYLrVlViqJnBQ8tC
        VLcmyRt+VfKBeXxzVPrKW8XuQqNGtXfBsNNaei2F1hrwdi1PuvUaBd1GRwlTlTdLZnBo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ntvaR-004GRh-Nf; Wed, 25 May 2022 20:18:23 +0200
Date:   Wed, 25 May 2022 20:18:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rodolfo Giometti <giometti@enneenne.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
Message-ID: <Yo5y763NprmBsJs/@lunn.ch>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch>
 <20220405124851.38fb977d@kernel.org>
 <20220407094439.ubf66iei3wgimx7d@skbuf>
 <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b90db13-03ca-3798-2810-516df79d3986@enneenne.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However we can modify the patch in order to leave the default behavior as-is
> but adding the ability to enable this hack via DTS flag as follow:

The fact you called it a hack suggests you know it is not likely to be
accepted.

> 
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> 
>                         port@0 {
>                                 reg = <0>;
>                                 label = "lan1";
>                                 allow-ptp-fallback;
>                         };

As Vladimir said, this is configuration, not a description of the
hardware.

	Andrew
