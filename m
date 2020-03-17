Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E1F188EE7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCQUWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgCQUWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 16:22:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5D02051A;
        Tue, 17 Mar 2020 20:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584476538;
        bh=IZOG5zp+Fc3qDB+N8SAvt8cnH4kTgVqxt5tjuPhZwBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HrKhbpjYunWstZgAbOtrBF958p0rQeGruZLnLvNMw532vOjImjgtfxP7KpMqR7836
         xdjrW8Iuqw43BB9NaoiH4u7mT76t/7RvJx2Wv/B4+zfSxf7chSLDsc8RkGK1F6YsY9
         /9QyqNSH/3VrVB76xcEWOZHO51ByfWpfJNujAIN8=
Date:   Tue, 17 Mar 2020 13:22:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V2 net 0/4] ENA driver bug fixes
Message-ID: <20200317132216.751d0fd8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1584428802-440-1-git-send-email-akiyano@amazon.com>
References: <1584428802-440-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 09:06:38 +0200 akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> ENA driver bug fixes

Acked-by: Jakub Kicinski <kuba@kernel.org>
