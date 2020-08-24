Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32851250AEA
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgHXVbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHXVbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 17:31:15 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBDE20702;
        Mon, 24 Aug 2020 21:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598304673;
        bh=bA4aoZIedFovWE0HiqyvyB7BCa6X6PNUG4yHARSoUn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TTA1g9IBcT0iksvl3LTSdn9UYBoU6YfJhvdmbiwFfqDAHJl+dfVOJhnQhTFUoIyS7
         YHX28363xpVfa5XKEiKtgnxuv8PaWkvKjaOd4G+T2cJHmM1/uFs8Cc4SaxJIGIRjAe
         HOIee1gbl7FF7+fzK5yKG7S11oLzuEcuyKBOyAnI=
Date:   Mon, 24 Aug 2020 14:31:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <Po.Liu@nxp.com>
Subject: Re: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
Message-ID: <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820081118.10105-1-kurt@linutronix.de>
References: <20200820081118.10105-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 10:11:10 +0200 Kurt Kanzenbach wrote:
> this series adds a DSA driver for the Hirschmann Hellcreek TSN switch
> IP. Characteristics of that IP:
> 
>  * Full duplex Ethernet interface at 100/1000 Mbps on three ports
>  * IEEE 802.1Q-compliant Ethernet Switch
>  * IEEE 802.1Qbv Time-Aware scheduling support
>  * IEEE 1588 and IEEE 802.1AS support

I don't see anything worth complaining about here, but this is not my
area of expertise.. 

DSA and TAPRIO folks - does this look good to you?
