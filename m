Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30D12B565E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgKQBoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKQBoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:44:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B73724694;
        Tue, 17 Nov 2020 01:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605577453;
        bh=3rXaXNiPouvrBirWjF+qukEwltzwCUwftGPgaz10NMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nCv377qgLncN/DkvO2DZk0XeLZZl5SvwVoBd5XYAlhjaWRVEvI59tkPreWBF36Tj+
         S05pEaGice7umiQHjEY2KMiHdXirPqRgqkNYPpTcPTfbiSRf4JaqwoF7D6/V0wSIlN
         t/pRY2L5i7MkPWBemc/5PUaexdYZMsBIYlMPYY1I=
Date:   Mon, 16 Nov 2020 17:44:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes.
Message-ID: <20201116174412.5ffe8bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605486472-28156-1-git-send-email-michael.chan@broadcom.com>
References: <1605486472-28156-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 19:27:48 -0500 Michael Chan wrote:
> This first patch fixes a module eeprom A2h addressing issue.  The next
> 2 patches fix counter related issues.  The last one skips an
> unsupported firmware call on the VF to avoid the error log.
> 
> Please queue the 1st 3 patches for -stable.  Thanks.

Applied, thanks!
