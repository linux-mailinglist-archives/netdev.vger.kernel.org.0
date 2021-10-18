Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D97432673
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhJRSge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:36:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRSgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4dQWqzn5O0dKep+wkTT5G/2xBwuPgJPVMz5BFh0KAsM=; b=BdQx593HAZj0bBi4OzdDfRNMef
        JnInn8w0bFF/qIZ6GA/h7HTUsSD+EhqYujbTB/5860WJmabHH73qzOwv25IOPJ4+M7knxyazFu7yw
        HGE5GZq8TASmIAYU6ma0G3C4b8Z08b6ZkCt40NNhMUdTcsVgHDtlHIYBjBG8ITpSbRHg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcXSk-00Azlf-Id; Mon, 18 Oct 2021 20:34:18 +0200
Date:   Mon, 18 Oct 2021 20:34:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 02/13] net: phy: at803x: use phy_modify()
Message-ID: <YW2+KlhvVYLbQP8S@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-3-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:33:22AM +0800, Luo Jie wrote:
> Convert at803x_set_wol to use phy_modify.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
