Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7002CF792
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387657AbgLDXb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:31:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbgLDXb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:31:57 -0500
Date:   Fri, 4 Dec 2020 15:31:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607124691;
        bh=ud3u7F/T4HfYK3Xoqy1X2eFUbJ7Wji9BrhWMCheL4l8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=VQccjtQxmC2qrLRwyM0lr805X3ZiUUKAsLG+gM5UFOwLTfsf+6G6XMxaB023FLKuk
         LSnawP4q0Yh0SV25wR+hOEt6N/f96HhQ4/eGeXd6xLaaLZ7BUH53wyqjMxWPc/EHcQ
         0dqJMiEXMvuRyA4A3dbG5+YMrAbO/CXlNX1juq2A88LeR0Q/8Z3cmumFRHF547ewsr
         ZmIfPpswZeT5L0po8KOBcyCWoMXqEOk59I5HmS4Yy0pw4AF1GMOmYrrOZnHrx+JqwF
         yy5o8MzI63RIWdHk9raY+Jd6bs79MZlmRn1dC598QJNnyLUFPb6lxLrEXXi4gL7bfp
         x9LhUFiTqm0tg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon2@gmail.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next] nfc: s3fwrn5: skip the NFC bootloader mode
Message-ID: <20201204153130.6e12e6fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204083753.GB5418@kozik-lap>
References: <20201203225257.2446-1-bongsu.jeon@samsung.com>
        <20201204083753.GB5418@kozik-lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 10:37:53 +0200 Krzysztof Kozlowski wrote:
> On Fri, Dec 04, 2020 at 07:52:57AM +0900, Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> > 
> > If there isn't a proper NFC firmware image, Bootloader mode will be
> > skipped.
> > 
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > ---
> > 
> >  ChangeLog:
> >   v2:
> >    - change the commit message.
> >    - change the skip handling code.  
> 
> Patch is now much cleaner and smaller. Thanks.
> 
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied, thanks!
