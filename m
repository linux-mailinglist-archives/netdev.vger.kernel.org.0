Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9726D91A84
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 02:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfHSAn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 20:43:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40330 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfHSAn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Aug 2019 20:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lMugEJt4cnK9k51RWef6u0jdy0vfdnqoQK03dOzJTog=; b=hl40ku5jUBIQVQjTFYSpJR+fXM
        Gd4XmCnOwVdqbiGv2D4nRkyJwELjNGhB9m/9a7FGxIPH7chWgY6rlpA3BIRN6oa+d9xx8L15fQRh8
        URbFpGIdAv1wqoOs0nAW4ndXdYHTUnHXU/UfH4AhV19/SLa54FCzMwQ74PMUilePN5bc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzVm6-0002Za-4R; Mon, 19 Aug 2019 02:43:54 +0200
Date:   Mon, 19 Aug 2019 02:43:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to
 the transfer structure
Message-ID: <20190819004354.GC8981@lunn.ch>
References: <20190816004449.10100-1-olteanv@gmail.com>
 <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk>
 <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
 <20190816125820.GF4039@sirena.co.uk>
 <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> MDIO bus controllers are in a similar situation (with Hubert's patch)
> but at least there the frame size is fixed and I haven't heard of an
> MDIO controller to use DMA.

Linux does not have any DMA driver MDIO busses, as far as i know. It
does not make sense, since you are only transferring 16bits of
data. The vast majority are polled completion, but there is one which
generates an interrupt on completion.

	Andrew
