Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54518EA47
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 17:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgCVQXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 12:23:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgCVQXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 12:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NcsGVSpv31H2jSgMa6+m2/GoI2+zLEO5nYONPLCUxLw=; b=P9gidKvUjXW7uiUNTMgicOmNgq
        SuTGwG5GDMLO5xdZxM6Lmi3CzTsDrssAyOmTrU/JJlJsmbK/W30dMN9fzsqihBq3HmaWojueQQM3Z
        FMttYjb2NFK35dMyeEzt4CFBH3z9r2WeSfwcpUZsiZkQcBEhMhDMIY2Ok01UqI9eBwlQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG3OC-0000ub-12; Sun, 22 Mar 2020 17:23:52 +0100
Date:   Sun, 22 Mar 2020 17:23:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, sd@queasysnail.net,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] macsec: restrict to ethernet devices
Message-ID: <20200322162352.GT11481@lunn.ch>
References: <20200322160449.79185-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322160449.79185-1-willemdebruijn.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 12:04:49PM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Only attach macsec to ethernet devices.
> 
> Syzbot was able able trigger a KMSAN warning in macsec_handle_frame

able to

Looks sensible otherwise.

     Andrew
