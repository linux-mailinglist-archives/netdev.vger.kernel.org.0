Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E72E2CF70B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgLDWoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgLDWoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:44:20 -0500
Date:   Fri, 4 Dec 2020 14:43:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607121820;
        bh=V1Y1bIE9gXsUYTIlj8PDqf2hxXK10wLOaarOV0cO9l4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LIb5QZ4yeWsAcliXtNqEyncTa8d21TGCatfO2QE3IgwICJ4OtXRsaq9wf4vj46z3i
         oSadK7UDws9O1n7U8s1b4gXYPS16a/SBFJXsRG2AhONrJBzKq38lf3C3OdnxXKn9+I
         vlYqpQbVVTUQhlY4AVW8M/hzeozKcj5eY6mtTceGrQ79e6KFroU+73H2xL14hlXt7q
         d0+qBbzCUSyBf4Z5VQF1uwK0jhUBYrF0ryX0CPW4Er55687JCEYAyQIjDmj1eZIb+9
         zz8nH9hl1k0bPr4NTMCgth2uYO+1sAxEKQYJALWcglTWnK7Dm7+/GhmicQS9SDvOG6
         tHE085/BhFNTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH] ethernet: select CONFIG_CRC32 as needed
Message-ID: <20201204144338.484d3d80@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203232114.1485603-1-arnd@kernel.org>
References: <20201203232114.1485603-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 00:20:37 +0100 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A number of ethernet drivers require crc32 functionality to be
> avaialable in the kernel, causing a link error otherwise:

> Add the missing 'select CRC32' entries in Kconfig for each of them.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks!
