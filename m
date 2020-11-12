Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC22AFF4D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKLFcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgKLBcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 20:32:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0732076E;
        Thu, 12 Nov 2020 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605144739;
        bh=aSW8m7Nv9ZNRf3+j642LjQr4G6QfPYtFZdHjwB8Z4vg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAvQmcVzjO9DdHdWWWAekODlYg+tfIDE6Nmw01n9dqJfMhGlYI/S0eGEew9QbBsAZ
         ZkmXxUqRIi35DKNGcHxSiOomiDb3O39mfoJa9kPv/yC7O9qkjFofiN7l2Xop2UYb1M
         sBnC/bQ02PnpLw10c+9/dFjCQZFD63uHL7DQEoww=
Date:   Wed, 11 Nov 2020 17:32:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock
 is ERROR
Message-ID: <20201111173218.25f89965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
References: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 09:15:05 +0800 (GMT+08:00) =E7=8E=8B=E6=93=8E wrote:
> >Grygorii, would you mind sending a correct patch in so Wang Qing can
> >see how it's done? I've been asking for a fixes tag multiple times
> >already :( =20
>=20
> I still don't quite understand what a fixes tag means=EF=BC=8C
> can you tell me how to do this, thanks.

Please read: Documentation/process/submitting-patches.rst

You can search for "Fixes:"
