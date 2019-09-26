Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0DBF2EE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfIZM13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:27:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfIZM13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 08:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=StYoawpBSbowJCICSKSTHJRHOTgYg6lhzDHkVcITLOQ=; b=flV6L3rvm23uCGI/xJSMLLu7Ty
        SFiHK5VBNgb4okWasHsInphvUyEJYmWsxewpywpmHIZtDQVGT7CTFtottSxjT0ngNPXtDVyZN1PEy
        JzEchwbg+eRzHmSBh8kq1hjbywMo8682rn6Tt7hLH1nbZDbffWVdTAVWcT+rEk7VOcaQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDSrm-00029O-NX; Thu, 26 Sep 2019 14:27:26 +0200
Date:   Thu, 26 Sep 2019 14:27:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net] devlink: Fix error handling in param and info_get
 dumpit cb
Message-ID: <20190926122726.GE1864@lunn.ch>
References: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 03:05:54PM +0530, Vasundhara Volam wrote:
> If any of the param or info_get op returns error, dumpit cb is
> skipping to dump remaining params or info_get ops for all the
> drivers.
> 
> Instead skip only for the param/info_get op which returned error
> and continue to dump remaining information, except if the return
> code is EMSGSIZE.

Hi Vasundhara

How do we get to see something did fail? If it failed, it failed for a
reason, and we want to know.

What is your real use case here? What is failing, and why are you
O.K. to skip this failure?

     Andrew
