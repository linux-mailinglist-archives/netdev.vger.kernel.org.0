Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161F42B89BA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgKSBnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbgKSBnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:43:23 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C85221F1;
        Thu, 19 Nov 2020 01:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605750202;
        bh=j8kTmGS6VBmz/MWm9ZzdQBbDxvw67SbeKGkiYJK/1dI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qBpS8QAiCGHvUauHrZgnM3EIUUo0P7KU+XofHrNXD1OyYChBNSrXpvIho4oKj3csY
         2Exz/ZM16dPxGM8wR9DbqJuebQTVYf2lZJAYDfBdmbPxOXmQSihvzCy5fhmaHfDqNQ
         M2IX45K4rQa+2cXIKD04XTdtZYY0HgTpEX/SY/d8=
Date:   Wed, 18 Nov 2020 17:43:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "krzk@kernel.org" <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] nfc: s3fwrn5: Remove the max_payload
Message-ID: <20201118174320.2544d62b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725@epcms2p3>
References: <CGME20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725@epcms2p3>
        <20201117080824epcms2p36f70e06e2d8bd51d1af278b26ca65725@epcms2p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 17:08:24 +0900 Bongsu Jeon wrote:
> max_payload is unused.
> 
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Applied all 3 to net-next, thanks!
