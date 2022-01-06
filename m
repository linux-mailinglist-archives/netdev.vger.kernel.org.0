Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F42348648B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbiAFMqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:46:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238901AbiAFMqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 07:46:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sb5puHWrCBvPHq+ETTuUx1fhkZYhyUxCv8saF9jxTbk=; b=wzrUKkcdWONH11pxB5CtDOKnoc
        go1Euvv5rNqrgnRjhUHLI9vh8vpwuV0mdMgQxVO4pu+kc9iNBZcbXqdW5g+Ui6++lQ/82QIySmV0V
        FluVH8QZLuWquQAScCHMcOYH33sV3dKv67gPkJJM+M5sGpXhz3Al4uaBOyEBvtvYGllM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5SA0-000eXn-3X; Thu, 06 Jan 2022 13:46:28 +0100
Date:   Thu, 6 Jan 2022 13:46:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     hkallweit1@gmail.com, kuba@kernel.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, ndesaulniers@google.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <YdbkpPDMkzqYzyg7@lunn.ch>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
 <YabEHd+Z5SPAhAT5@lunn.ch>
 <f91f4fff-8bdf-663b-68f5-b8ccbd0c187a@loongson.cn>
 <257a0fbf-941e-2d9e-50b4-6e34d7061405@loongson.cn>
 <ba055ee6-9d81-3088-f395-8e4e1d9ba136@loongson.cn>
 <5838a64c-5d0a-60a1-c699-727bff1cc715@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5838a64c-5d0a-60a1-c699-727bff1cc715@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi phy maintainer,
> 
> What's your viewpoint?

Russell is a PHY Maintainer.

I suggest you stop arguing with him. Test what Russell proposes, and
let him know if it solves the problem you were seeing.

	Andrew
