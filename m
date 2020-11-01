Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405732A1B51
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 01:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgKAAEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 20:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgKAAEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 20:04:11 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39EB320791;
        Sun,  1 Nov 2020 00:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604189051;
        bh=2RpowNaj7qzCF6a+k6nLR3y08AyTOmxcV5Xx7TmdGh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MvZKcnseZwzNqjpMOn46+/MI5zSXGLFDmkP1F/3rd1Y1aZYF0NbdF2cW/Xrebc4rU
         Na0ZHLPjh4fWJnVnjP1eCYeo37IG/RbOku1NRLu46FfQx60g77Y94KCJtRuDOb4Bed
         WrZTiK+j4+hyRV0cM7Vs6la8TZOB3lpOyCHkEqmc=
Date:   Sat, 31 Oct 2020 17:04:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Deneen <mdeneen@saucontech.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, Klaus Doth <krnl@doth.eu>
Subject: Re: [PATCH net v3] cadence: force nonlinear buffers to be cloned
Message-ID: <20201031170410.0fd22cd0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030155814.622831-1-mdeneen@saucontech.com>
References: <20201030155814.622831-1-mdeneen@saucontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 15:58:14 +0000 Mark Deneen wrote:
> In my test setup, I had a SAMA5D27 device configured with ip forwarding, =
and
> second device with usb ethernet (r8152) sending ICMP packets. =C2=A0If th=
e packet
> was larger than about 220 bytes, the SAMA5 device would "oops" with the
> following trace:

Applied, thanks!
