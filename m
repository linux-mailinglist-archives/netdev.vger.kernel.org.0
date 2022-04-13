Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD350006E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiDMVAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 17:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiDMVAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 17:00:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66087304E;
        Wed, 13 Apr 2022 13:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FjOfuKGaW3+n8OXwgMrR+7BrXgJXD0Lo0EH34BrqZsA=; b=OvjalHIZFLbYcq4GRFdAD2jMnY
        7dVLL9aWPh80xs82yO5nWdfZp5pxMPN+DjdGxoE74witMxLJvTKHp5TPD0PSapDT5qz+ULnomL7u2
        wXpoEajKXtF4HEzjhKDS7OCS4Rp2mm36oCDY6SblpcRgx5MXTJI49laXeANoMQyKnETs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nek3a-00FjSN-JF; Wed, 13 Apr 2022 22:57:42 +0200
Date:   Wed, 13 Apr 2022 22:57:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Message-ID: <Ylc5RhzehbIuLswA@lunn.ch>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf>
 <Ylc3ca1k1IZUhFxZ@lunn.ch>
 <20220413205350.3jhtm7u6cusc7kh3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413205350.3jhtm7u6cusc7kh3@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I meant to ask about the actual mv88e6060 driver, the one that uses
> tag_trailer.c, not mv88e6xxx.

Ah, sorry, i don't have one of those. And i've no idea of anybody who
does. It is a long long time since i heard of anybody with one.

      Andrew
