Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E328C6EFC0F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbjDZU6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbjDZU6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:58:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310542D7D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qDpZSebwWOScRvP6zvxkbV73MKAMroSL55k9sWmtC+c=; b=b6JGTdvdJJ0jXKTK414uGB9Wps
        cNZ6cGFZxfqURlwyzz7HRjw04Qj1BRSo4xMmGWNxQpnDKkSck+tr666vO5f1M4jPvqYYHBeOLtvE6
        vXR8xVEbuwCUBqDzonjZuCvrGjqt6lDZ+PY65kbyKFousOBsYZxUsTRC7z4LU34XzDwQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prmDD-00BIrl-Cs; Wed, 26 Apr 2023 22:58:03 +0200
Date:   Wed, 26 Apr 2023 22:58:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org,
        Angelo Dureghello <angelo.dureghello@timesys.com>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu
Message-ID: <ca479bae-900a-4ccb-aa00-aaa5d5e9589a@lunn.ch>
References: <20230426202815.2991822-1-angelo@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426202815.2991822-1-angelo@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 10:28:15PM +0200, Angelo Dureghello wrote:
> From: Angelo Dureghello <angelo.dureghello@timesys.com>
> 
> Add rsvd2cpu capability for mv88e6321 model, to allow proper bpdu
> processing.
> 
> Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
> Fixes: 51c901a775621 ("net: dsa: mv88e6xxx: distinguish Global 2 Rsvd2CPU")

This is for net.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
