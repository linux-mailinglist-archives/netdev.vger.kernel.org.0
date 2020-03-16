Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D57B186FB0
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 17:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbgCPQJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 12:09:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38484 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731867AbgCPQJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 12:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a4SkyFwUTn7jLPIQJrqhF70q9YReVX9hTIk2qJVhEFY=; b=oAFdRSRyjwGA7rmlMrui7YjmX7
        6MUbLJdG8hTMakntHtFtg5dD83ME/J5rQCvdToEkBQCsbgUHM01oSHhvcYU0SwEr5m70zMTS/dx87
        rM3sKo1qthSpM89vbkiTUIthGPOAnrwswfJPqn+k23PEHmeCYS1Y3tOHFFIXn3dYmqpI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDsJ5-00085n-Kr; Mon, 16 Mar 2020 17:09:35 +0100
Date:   Mon, 16 Mar 2020 17:09:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Message-ID: <20200316160935.GA30840@lunn.ch>
References: <1584360358-8092-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1584360358-8092-2-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584360358-8092-2-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 02:05:56PM +0200, Madalin Bucur wrote:
> Treat all internal delay variants the same as RGMII.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
