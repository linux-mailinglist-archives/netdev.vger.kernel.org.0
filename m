Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B951C0613
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgD3TUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:20:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgD3TUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6tLUsXF70kcYObbvMwRiIHmbpt5HqH536gReCWJ1xW4=; b=1nC5FpLzMaB8I64OW6SVU6TPdx
        MY2v00hhy3oPxFUKmJTU/OA147irMQg/XtpYq2FvrG0GkhdWiAssuUxq3pvvcjn0TKp3fqJZjmTi6
        nu0Zw8XQmRNxOJT3RsKnv7sDquI5dyd5Qpfp0aZDmRd7KNH0aYa/yUK0H4SfKr/dcjQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUEjX-000S80-Db; Thu, 30 Apr 2020 21:20:31 +0200
Date:   Thu, 30 Apr 2020 21:20:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: b53: Provide number of ARL buckets
Message-ID: <20200430192031.GC107658@lunn.ch>
References: <20200430184911.29660-1-f.fainelli@gmail.com>
 <20200430184911.29660-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430184911.29660-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:49:09AM -0700, Florian Fainelli wrote:
> In preparation for doing proper upper bound checking of FDB/MDB entries
> being added to the ARL, provide the number of ARL buckets for each
> switch chip we support. All chips have 1024 buckets, except 7278 which
> has only 256.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
