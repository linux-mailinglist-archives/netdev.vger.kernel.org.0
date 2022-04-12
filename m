Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890294FC92C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240415AbiDLAUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240338AbiDLAUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:20:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286DF1C10D;
        Mon, 11 Apr 2022 17:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4JejSNvCJX2CI8+uPW+i37EPrfsaIiLcHqu56LNBXTk=; b=NAvAlHPem2HgX3sTPQ25vElX7Z
        7VKmILEkx6xnRWdnUcWhzX8eAvzK5H79rs2pLa6zWUaiYRcj6GZlcDsaHdzFtsS5ZjS3zMNflrEWV
        SgMxIAYKJGDjj5qgQI75uKWZ/cYqZCupIeuei2mSdds537SL8dLkt6myxRcnyGtp/kyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ne4EY-00FLah-3D; Tue, 12 Apr 2022 02:18:14 +0200
Date:   Tue, 12 Apr 2022 02:18:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        tobias@waldekranz.com, f.fainelli@gmail.com,
        vladimir.oltean@nxp.com, corbet@lwn.net, kuba@kernel.org,
        davem@davemloft.net,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Message-ID: <YlTFRqY3pq84Fw1i@lunn.ch>
References: <20220411210406.21404-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411210406.21404-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 06:04:07PM -0300, Luiz Angelo Daros de Luca wrote:
> RTL8367RB-VB was not mentioned in the compatible table, nor in the
> Kconfig help text.
> 
> The driver still detects the variant by itself and ignores which
> compatible string was used to select it. So, any compatible string will
> work for any compatible model.

Meaning the compatible string is pointless, and cannot be trusted. So
yes, you can add it, but don't actually try to use it for anything,
like quirks.

     Andrew
