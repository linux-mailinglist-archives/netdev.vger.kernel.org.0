Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4943A2ED0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhFJO7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:59:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhFJO7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 10:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6VMkBxJVMb4llnPeG01oVtHAShtkJHPG7miABnV2szM=; b=EXLoYsOiEtnCIsqltslkk7LckW
        QxRXMeP/Ll+CfqiYnl4StFQOcoTmuIxrvMbxLQbx+5DYCdCqqGCtxvc5XRYC9YNxO/Gje+tdvV0nP
        oF+Mcr16TA+hDlkecANfpvBp2A1AgdMtPTzOILwj1gfEa4LS8PvlBhhn2GyO7hII8sNI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrM7d-008fyM-Dk; Thu, 10 Jun 2021 16:57:29 +0200
Date:   Thu, 10 Jun 2021 16:57:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhou Yanjie <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YMIoWS57Ra19E1qT@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YMGEutCet7fP1NZ9@lunn.ch>
 <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
 <YMICTvjyEAgPMH9u@lunn.ch>
 <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
 <12f35415-532e-5514-bc97-683fb9655091@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f35415-532e-5514-bc97-683fb9655091@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here is Ingenic's reply, the time length corresponding to a unit is 19.5ps
> (19500fs).

Sometimes, there is a negative offset in the delays. So a delay value
of 0 written to the register actually means -200ps or something.

   Andrew
