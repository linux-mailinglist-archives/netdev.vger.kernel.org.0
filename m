Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E655E319A9B
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 08:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBLHgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 02:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhBLHe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 02:34:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F6E64DDF;
        Fri, 12 Feb 2021 07:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613115251;
        bh=neLigVsdoN+CYxyJjxX/qAVzIuWLkdZyDMtjMwYqrLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HXxvvzoLkjPDeR3JvcBQ0yM6umQwZkmsCLbD2ensoMiDSwJ12mr5vWKrB0DrZiHW7
         Gekvt4dNU/S+p5AIGSg4dt+0WYDyTcu/6XVXII5HxZO1gqLk/3yDI3Wlulmpn0zOJp
         7rgsu6cSkxMG72w51fu99lYoEdiG5ZacmY648UG0=
Date:   Fri, 12 Feb 2021 08:34:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Gilles Muller <Gilles.Muller@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, cocci@systeme.lip6.fr,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 0/2] of: of_device.h cleanups
Message-ID: <YCYvcUNiPoG/ipyj@kroah.com>
References: <20210211232745.1498137-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211232745.1498137-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 05:27:43PM -0600, Rob Herring wrote:
> This is a couple of cleanups for of_device.h. They fell out from my
> attempt at decoupling of_device.h and of_platform.h which is a mess
> and I haven't finished, but there's no reason to wait on these.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
