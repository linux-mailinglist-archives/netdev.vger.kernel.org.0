Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E9C151334
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgBCX14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgBCX14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 18:27:56 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E227D20720;
        Mon,  3 Feb 2020 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580772476;
        bh=zj6vzTgY+ian5h9Uf9Ldr10pMfEKnXzI/V7kIzpmx9g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NT6CLo0AqPlmIL/kiubEMrt0qooJHBiCUm1i6MBmMGyMm8nUE2QYZ0qWBNdBjwAw9
         38HxWf6AuL8jROwEzZ8ZnGaPYU5MDpe4QNPAhakeLkDJW92jeSxzTorbxGZpvgETHT
         SXW8URiGTjdbxFQm7DvdreG3q3VbRy4LuR7Q6uVo=
Date:   Mon, 3 Feb 2020 15:27:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [stable] bnxt_en: Move devlink_register before registering
 netdev
Message-ID: <20200203152755.577057b0@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CACKFLi=8uYrOx9GM412hArXzFHZW7WpD3P4F_hT5S0bgf_YTjA@mail.gmail.com>
References: <CACKFLi=8uYrOx9GM412hArXzFHZW7WpD3P4F_hT5S0bgf_YTjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 23:42:00 -0800, Michael Chan wrote:
> David, I'd like to request this patch for 5.4 and 5.5 stable kernels.
> Without this patch, the phys_port_name may not be registered in time
> for the netdev and some users report seeing inconsistent naming of the
> device.  Thanks.
> 
> commit cda2cab0771183932d6ba73c5ac63bb63decdadf
> Author: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Date:   Mon Jan 27 04:56:22 2020 -0500
> 
>     bnxt_en: Move devlink_register before registering netdev

Queued!
