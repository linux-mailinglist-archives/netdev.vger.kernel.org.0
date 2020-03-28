Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A77019671F
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgC1Poc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:44:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgC1Pob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 11:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dhdKFxOXND7oIsFat8qeG+GWKPr56Dqi6UeFXsyE0mA=; b=sZN2yEzsvu9z3vw5uQZifx+IEy
        uO+KHHW2R+ejO9aIFfzYJUtArlXKqwhKGlcuR11UVNlFvCECpwibFkjXA3GokJLbaF4/LZKPxPh/+
        zZ89twKWqmmeLweH00D5aLv+bs5MEi1Ou6UPSx4ztvSAsAm2K0h0+e+O38pFkk3j8plg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIDdI-0003sq-Kb; Sat, 28 Mar 2020 16:44:24 +0100
Date:   Sat, 28 Mar 2020 16:44:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Simplify 'dsa_tag_protocol_to_str()'
Message-ID: <20200328154424.GW3819@lunn.ch>
References: <20200328095309.27389-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200328095309.27389-1-christophe.jaillet@wanadoo.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 10:53:09AM +0100, Christophe JAILLET wrote:
> There is no point in preparing the module name in a buffer. The format
> string can be passed diectly to 'request_module()'.
> 
> This axes a few lines of code and cleans a few things:
>    - max len for a driver name is MODULE_NAME_LEN wich is ~ 60 chars,
>      not 128. It would be down-sized in 'request_module()'
>    - we should pass the total size of the buffer to 'snprintf()', not the
>      size minus 1
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
