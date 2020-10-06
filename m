Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24109285331
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgJFUgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgJFUgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 16:36:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8204520866;
        Tue,  6 Oct 2020 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602016598;
        bh=VuOCzWDqflGcRgZnl9Iu5mTo/EW0SVEkSw+9fVTmtSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ge9/bmWUBcLVONh3KyDb+gqLoPR+3nnif059p7wPLL5hbwqgw9Ib21F09CRWUjIA2
         KYpaqym+iF2WQdCY/UD4DVYAvYU4CIJYBx5SClVEwW9zbFLLX2zZG1cLnz4JOoBRt2
         tilTPZyllnpi62Q6Ktut2beTelm7O4Co8AUI2l0E=
Date:   Tue, 6 Oct 2020 13:36:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net v2] net: dsa: microchip: fix race condition
Message-ID: <20201006133635.4d8f1fe7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006155651.21473-1-ceggers@arri.de>
References: <20201006155651.21473-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 17:56:51 +0200 Christian Eggers wrote:
> Fixes: 7c6ff470aa ("net: dsa: microchip: add MIB counter reading support")

Fixes tag: Fixes: 7c6ff470aa ("net: dsa: microchip: add MIB counter reading support")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
