Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CEC30FE09
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhBDUUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239866AbhBDUUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:20:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C8B264F45;
        Thu,  4 Feb 2021 20:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612469437;
        bh=YhgF/qgTPY8xFI7LRUcob72nphckTIs1Ky/KJ/BOUPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vKXya9B1n25r1qlsDF21Zhj0wl5lQaXokuyN5pNXjOJnu24Dr5EDdN+uKdcEkJj7C
         e93v72JRhPW4CnOhjtSJJFGreTmZO1sdfPdyd+wDian8Nk9BfgF2fiDXzB0g24D7eL
         N2+56NTz/BZHkt8DrUM1OG0jSn4ivSjhSpDfFiZc8iLTfNrd8luVSgGzqtk5KDEtU/
         vBNHjJqckgoY5kqrp+3Kr0HhHSrrNEFYQxHvVep9ADKiu9ga49hs+b7wQck8KNmw3G
         UtIy06IZW/q72le8AMPmfMEB+qns5pAFOEnA+xi8ZRrvKbnI/qkEfXFFIUwpBEJLIS
         FehDLEH+nu0qA==
Date:   Thu, 4 Feb 2021 12:10:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     laforge@gnumonks.org, netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 0/7] GTP
Message-ID: <20210204121036.3973b97f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
        <20210203070805.281321-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 08:07:58 +0100 Jonas Bonn wrote:
> There's ongoing work in this driver to provide support for IPv6, GRO,
> GSO, and "collect metadata" mode operation.  In order to facilitate this
> work going forward, this short series accumulates already ACK:ed patches
> that are ready for the next merge window.
> 
> All of these patches should be uncontroversial at this point, including
> the first one in the series that reverts a recently added change to
> introduce "collect metadata" mode.  As that patch produces 'broken'
> packets when common GTP headers are in place, it seems better to revert
> it and rethink things a bit before inclusion.

Applied, thanks.
