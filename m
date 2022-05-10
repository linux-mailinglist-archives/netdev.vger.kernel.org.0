Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88551520A50
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiEJApm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiEJApi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:45:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390AD23152;
        Mon,  9 May 2022 17:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+9Jcndtdt5j+87VgNhYo6ZjaqyPBOSRW/u94I+XIY0U=; b=B514UUT0cVzXUvUasKbIwFal6N
        OPhUm9sHA4aKE8HYdg1DtEI2ftBETpP9XC/Q9Md1wgzlVmsuK8YQFDGDKh/2JSERV2aVWZY/LVuBS
        SvU+teaNKFMxqUBU4O/iTfYFFe1KO5usgpEPxJFiR2/TAjrEM31wb75OYP3w/CjhePpo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1noDwM-0021wC-Dp; Tue, 10 May 2022 02:41:26 +0200
Date:   Tue, 10 May 2022 02:41:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <Ynm0tm7/05ye9z6v@lunn.ch>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
 <20220509172814.31f83802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509172814.31f83802@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:28:14PM -0700, Jakub Kicinski wrote:
> On Fri,  6 May 2022 09:06:20 +1200 Chris Packham wrote:
> > Subject: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
> 
> JSON or YAML?

JAML is a superset of JSON. So it is not completely wrong. I've no
idea if this particular binding sticks to the subset which is JSON.

     Andrew
