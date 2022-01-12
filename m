Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303BC48C9E4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241275AbiALRhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355758AbiALRge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:36:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE219C061751;
        Wed, 12 Jan 2022 09:36:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1580B81EA1;
        Wed, 12 Jan 2022 17:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209A0C36AEB;
        Wed, 12 Jan 2022 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642008991;
        bh=zBRPIyPp6oesmkdO1v71djmT7VdtBWFe16odSnftCvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i6RplR0U0jxWZ3QApIwzN4DZ8OVd/Tpmr0JdZrPqDSfRnrJnclsXHRyu+iLjrz4Uv
         iOGcrIHsQP4M/Vgwq4AxdF+OonPYfeZSnwApvyPUrvcaoBUi9efatPpymZHU4ZFlVz
         AHIHImesU8Yk8BrKk2dMdiTluN1Z/x56DO1Fx6sqe5n2+f1eaMdWNzzeBZ+1ZEbA1J
         A5mI1KM5n7v567YhWxxUgyU2usXWIfy3KObWvmDuaVQcUc2T/E08EKxU5VcVOxGGVW
         hZT1bBWD8ILAv8yny/N69EHcZaC1cPGjCGC0ZgkLM/sMWYN2ZWa2rMnqyJYyJj2LpL
         YI0BqvjPMIypw==
Date:   Wed, 12 Jan 2022 09:36:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux-oxnas@groups.io,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ARM: ox810se: Add Ethernet support
Message-ID: <20220112093629.03ffcb65@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104145646.135877-1-narmstrong@baylibre.com>
References: <20220104145646.135877-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jan 2022 15:56:43 +0100 Neil Armstrong wrote:
> This adds support for the Synopsys DWMAC controller found in the
> OX820SE SoC, by using almost the same glue code as the OX820.

Alright, patches 1 and 2 are in net and on their way to 5.17. Thanks!
