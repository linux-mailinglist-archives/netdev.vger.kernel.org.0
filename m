Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FDE4FBD10
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346401AbiDKNbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346483AbiDKNbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:31:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9737252
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jBi+GkQHS2wMRUVOvCAZ9Z9t8eQcjp3BGL2kQfLG2lw=; b=fUBsjRG+FJc7LxxB6PlS7xlcT5
        A+jRGBsQAKC4YUMy7nPvPmeSO9WOGLYlTuPFx16PjoG0jPABIisoyPw1qlb+Xc5SgGKTXQpW6O8in
        CxI4nqy3kXI0fTJKZn0ErGE7KZnYP5sV/doZAz9s1zzz+ZtFpb1m0Qvexh+PbFhckPZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ndu6K-00FGU6-PF; Mon, 11 Apr 2022 15:29:04 +0200
Date:   Mon, 11 Apr 2022 15:29:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Erez Geva <erez.geva.ext@siemens.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information
Message-ID: <YlQtII8G2NE7ftsY@lunn.ch>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411131148.532520-2-erez.geva.ext@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:11:48PM +0200, Erez Geva wrote:
> Provide a callback for the DSA tag driver
>  to fetch information regarding a traffic control.

Hi Erez

When you add a new API you also need to add a user of it. Please
include your tag driver change in the patchset.

	Andrew
