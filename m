Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7DE34DE
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393877AbfJXN65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:58:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbfJXN64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4h4g4xWUSzQkOzsFtj/+EUfueq7HCHgHxDUC8+NHICM=; b=oXbbbanSQTTccq/4q8hM8qratB
        Zr3jaXlry1YfYCgEwaWqSMfdUZtp/MbIKwOBLIVi9ughnWdu8o7t0CZbpgAaTOEmAue2emWkloaZz
        gJkh/VHsrp73SsoDKb7WngLvDrgUT5VhPTuO+E8B7q0LQ3KcmJZ4IRV2hIFLs+a6wgWQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNddb-0003vD-1j; Thu, 24 Oct 2019 15:58:51 +0200
Date:   Thu, 24 Oct 2019 15:58:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: qca8k: Initialize the switch with
 correct number of ports
Message-ID: <20191024135851.GB30147@lunn.ch>
References: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 03:46:58PM +0200, Michal Vokáč wrote:
> Since commit 0394a63acfe2 ("net: dsa: enable and disable all ports")
> the dsa core disables all unused ports of a switch. In this case
> disabling ports with numbers higher than QCA8K_NUM_PORTS causes that
> some switch registers are overwritten with incorrect content.
> 
> To fix this, initialize the dsa_switch->num_ports with correct number
> of ports.
> 
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
