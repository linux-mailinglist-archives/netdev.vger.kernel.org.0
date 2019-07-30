Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4589C7AA72
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfG3OAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:00:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfG3OAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X0UhxBh/ipBoS6RSKb0U7EymdHQvy3/WfQmULMm8SgE=; b=QbN5sdEWf1w8RZaGCvyY3d2O1d
        /3OWn2awLSkL9Aq0U0J2/m89RcMh9uRRlNi/Me68OefIa0rpzcFz3ChVeyMSOBnKYYtptTtaEnd9+
        SvzvXsd8F3aG/lpqzSYg/VKm02MRZhly2OutoCbygta0YyR0EturbM+DeNPepXdHSBic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSgN-00082P-IX; Tue, 30 Jul 2019 16:00:51 +0200
Date:   Tue, 30 Jul 2019 16:00:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: use link-down-define instead of
 plain value
Message-ID: <20190730140051.GK28552@lunn.ch>
References: <20190730101142.548-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730101142.548-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:11:42PM +0200, Hubert Feurstein wrote:
> Using the define here makes the code more expressive.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
