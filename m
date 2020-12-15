Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0514E2DA4FA
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLOAh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 19:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgLOAhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 19:37:14 -0500
Date:   Mon, 14 Dec 2020 16:36:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607992594;
        bh=CxLawj9dsOGAed/kPedVVsaoAaw0SNvHP3d6248ghy4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GkEwhUxH4JR1wIJ30RuL/MWyOn8I0Ya+bFetXKJo8I42b2QwiJ2Csbh00gduwUwrl
         KFco/IYAXquyDBXPrgyQtIBRqFrXSNQRhLmGf2gXU8AEadUnVqockSUgCVWZZghVO8
         95xykvQRyfFNw9UxUtZFsae80AOoqnQeOBF9xpfSZ9iThIrrGAnLm5CBtLh+P3AFCY
         VX2wvxRgN9Lp5BY3PdipMbUKVLJU/9LwFUCY7EGXd8bmXd7s7/MQeJwgsVe1qPBqvE
         4gSF/2ZyHWt3ZFfO0GSY/fJZL8HxOzW/YBaksOZCqUTfdkGjdehLojprxrq25EcPvg
         ldMFk43BWgdPA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     sylvain.bertrand@legeek.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][c89] wrong usage of compiler constants
Message-ID: <20201214163633.3ece1ff3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <xxx666hutenoshurhpmr4kmer7notkhoec@freedom>
References: <xxx666hutenoshurhpmr4kmer7notkhoec@freedom>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 16:30:01 +0000 sylvain.bertrand@legeek.net wrote:
> From: Sylvain BERTRAND <sylvain.bertrand@legeek.net>
> 
> Using a c89 compiler fails due some wrong usage of compiler constants.

Are you saying it fails on some known compilers in the code you're
fixing? We have a strong preference to ask contributors to fix
compilers.

> Trivial and harmless fixes.

Code churn, longer lines, and another thing for developers to remember
are not harmless.
