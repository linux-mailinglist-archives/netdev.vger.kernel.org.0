Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5753D3939
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhGWKdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhGWKdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:33:13 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD2CC061575;
        Fri, 23 Jul 2021 04:13:46 -0700 (PDT)
Received: from mwalle01.kontron.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EEF5F221E6;
        Fri, 23 Jul 2021 13:13:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627038824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YksVhrYGZwm9bg1OCBw8O8OZ/3uHD5DEZUQ5vE5th88=;
        b=OdZKZ5C2gMzqXAdliUIQtDtAtHXiZ3ihy9rjghejkxVgJwfU/8a4KzrVb5qZKQzQl6oaoE
        /axLJPvtK+OqRVcSVkn4eXyoqdnXRi7NJ7Bdj7eDigRD+c3f0fMJko6OfLWOEAai8gPdR9
        mkSNnryfP063CFTaufAIwq7tsM+EhTQ=
From:   Michael Walle <michael@walle.cc>
To:     ansuelsmth@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com,
        vivien.didelot@gmail.com, Michael Walle <michael@walle.cc>
Subject: Re: [RFC] dsa: register every port with of_platform
Date:   Fri, 23 Jul 2021 13:13:28 +0200
Message-Id: <20210723111328.20949-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723110505.9872-1-ansuelsmth@gmail.com>
References: <20210723110505.9872-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The declaration of a different mac-addr using the nvmem framework is
> currently broken. The dsa code uses the generic of_get_mac_address where
> the nvmem function requires the device node to be registered in the
> of_platform to be found by of_find_device_by_node. Register every port

Which tree are you on? This should be fixed with

f10843e04a07  of: net: fix of_get_mac_addr_nvmem() for non-platform devices

-michael
