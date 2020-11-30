Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCCD2C8A0E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgK3Q40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbgK3Q4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 11:56:24 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D697207FF;
        Mon, 30 Nov 2020 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606755343;
        bh=n9PLatacUmUqjbbYGixPOPRFr9s5029uTjWhzTV1E90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NpzEiKcGgCggEvzLGU5tjHtz99cHEMCxhtxpiMBZtE9YM0vqwBjhYLAQ9hHobfRsH
         halPaG7nk71LGh0jOAxiSzVqroiS45VYzdk8kRcUdFXL3/oWEPbag0MdaGXjngrONP
         NXV5iDA/PWOYwfU/UQBYHV6iNnOb2+74C17HvOqA=
Date:   Mon, 30 Nov 2020 08:55:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu jeon <bongsu.jeon2@gmail.com>
Cc:     krzk@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support
 a UART interface
Message-ID: <20201130085542.45184040@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 21:00:27 +0900 Bongsu jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

All patches in the series should have the same version.

If the patch was not changes in the given repost you can add:

 v3:
  - no change

Or just not mention the version in the changelog.

It's also best to provide a cover letter describing what the series
does as a whole for series with more than 2 patches.
