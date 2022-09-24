Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D889B5E8D57
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 16:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiIXOcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 10:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiIXOcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 10:32:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ACB814C4
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 07:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l4xjwj1AugGMFeBxINKbYpHYWqznJMx8q3Pdcvt0zes=; b=r5eCXuipVfYc0m0oL+HUZNkauc
        Q0MGKEg9T/4jJgjUzRN+TzV5w4mqRImkZKIocm98u/sYXmn6UgHKH/sqVgsM1DF6Gu5uUCfoLGhW9
        edZA3tX25926xqory9/gHdbfzN5q5v5YmxlfzA2Gtn2C76T9RDzX6r2THmY/DXRb86iE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oc6CV-0007Os-Qc; Sat, 24 Sep 2022 16:32:15 +0200
Date:   Sat, 24 Sep 2022 16:32:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
Message-ID: <Yy8U71LdKpblNVjz@lunn.ch>
References: <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220923224201.pf7slosr5yag5iac@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923224201.pf7slosr5yag5iac@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My understanding of the autocast function (I could be wrong) is that
> it's essentially one request with 10 (or how many ports there are)
> responses. At least this is what the code appears to handle.

The autocast packet handling does not fit the model. I already
excluded it from parts of the patchset. I might need to exclude it
from more. It is something i need to understand more. I did find a
leaked data sheet for the qca8337, but i've not had time to read it
yet.

Either the model needs to change a bit, or we don't convert this part
of the code to use shared functions, or maybe we can do a different
implementation in the driver for statistics access.

	  Andrew
