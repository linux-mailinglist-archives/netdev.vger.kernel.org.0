Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEA2F77FC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKKPpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:45:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfKKPpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 10:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kgmZQI0f/UUfWrWxSTb4MJqjH3ehHYAovMhKuF2hHu4=; b=wUvpvI5j0kftAHXjsHGxeGHyMy
        BbAY1U9oOW1Euqcf/38jwQyGZBlS0MgtqB2xKIs6w8Gt4OunawTP4YNbFlIFkwymWYobJF21UOX2F
        WFG6392luLKoZ94H3jkZtVW/fWouRE04S5xoZYUtbFXNJMoTf1Z4J2hlBMhG9ZwIDFpE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUBsd-0002um-Di; Mon, 11 Nov 2019 16:45:27 +0100
Date:   Mon, 11 Nov 2019 16:45:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, brouer@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111154527.GA10875@lunn.ch>
References: <20191111134615.GA8153@lunn.ch>
 <20191111143352.GA2698@apalos.home>
 <20191111150553.GC1105@lunn.ch>
 <20191111151436.GC4197@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111151436.GC4197@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Maybe I got the issue. If mvneta_bm_port_init fails (e.g. if
> CONFIG_MVNETA_BM_ENABLE is not set) rx_offset_correction will be set to a wrong
> value. To bisect the issue, could you please test the following patch?

Hi Lorenzo

Did not help. Received packets are still corrupt.

    Andrew
