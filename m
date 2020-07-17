Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C57722443D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgGQTaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgGQTaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 15:30:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5F812064C;
        Fri, 17 Jul 2020 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595014220;
        bh=juw3bSbNrJrVoY9q98Rq6m4Gn1FeRtD+TlMXtzT1804=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HlJP+YP45X/Vm6sj9afn8hhEgblC0/MtS+ZdH2MMnHOYMmCadmOUS+4veaP2Z5kUc
         OfGicvoDJFGxMANDS1Qqw1k4jG4C63W1208J95O9/4f/qhjT1nLxQuS1wmNS1w2h2a
         ZV9UI5AGjW6Eo7vjKqKUC02+m1x5alwV3eYTwmDI=
Date:   Fri, 17 Jul 2020 12:30:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/6] enetc: Add adaptive interrupt
 coalescing
Message-ID: <20200717123014.4a68dad4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595000224-6883-7-git-send-email-claudiu.manoil@nxp.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
        <1595000224-6883-7-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 18:37:04 +0300 Claudiu Manoil wrote:
> +	if (tx_ictt == ENETC_TXIC_TIMETHR)
> +		ic_mode |= ENETC_IC_TX_OPTIMAL;

Doesn't seem you ever read/check the ENETC_IC_TX_OPTIMAL flag?
