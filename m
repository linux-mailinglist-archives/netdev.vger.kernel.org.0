Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86161824D0
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgCKWZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:25:19 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60702 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbgCKWZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 18:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zoMKw5hBPldeyDV/XzXql3f4Lza+9rVoslLVy16220o=; b=GCcEDNkZskVRuwHHJOQG38em4
        g7Wnk0AmCQRIWFIHPA1hzTQS95YOIFMHg3YV91HiNnTs0h3m7QAcSTShfYWl1wW1BA3Z232uHqvM5
        IKpvzimU7SleKBszGsRqb03YXxUM+AGR9tm14C8g+jk+H617Jz+z+8JQXkUPpvpuXRAp/Y8tgOJ+W
        M2raVSlLovoyUflLscqlUemEtm4z1fpZlR0Y0nJ1YW7WG1fLaC5Wmm9qvn7zHiYqCIGDNQ3JPjmvf
        Ando/vA+MradyuetoL69KzX3Sui7APWzbQg1P+qFLCFYLQFChvCGAInif7Vne3HztuuEMrnzaxdhv
        4r3Z9fJhw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:59268)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jC9mr-0005r6-SK; Wed, 11 Mar 2020 22:25:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jC9mq-0005h0-J8; Wed, 11 Mar 2020 22:25:12 +0000
Date:   Wed, 11 Mar 2020 22:25:12 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Peter Lister <peter@bikeshed.quignogs.org.uk>
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Reformat return value descriptions as ReST lists.
Message-ID: <20200311222512.GV25745@shell.armlinux.org.uk>
References: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
 <20200311192823.16213-2-peter@bikeshed.quignogs.org.uk>
 <20200311203817.GT25745@shell.armlinux.org.uk>
 <db5f6d8f-beb0-b9bd-e47d-2a8e3dd513a2@bikeshed.quignogs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db5f6d8f-beb0-b9bd-e47d-2a8e3dd513a2@bikeshed.quignogs.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 10:21:41PM +0000, Peter Lister wrote:
> Hello Russell,
> 
> > Is this really necessary?  This seems to be rather OTT, and makes the
> > comment way too big IMHO.
> 
> The existing form definitely gets the formatted output wrong (I'll send you
> a screen grab if you like) and causes doc build warnings. So, yes, it needs
> fixing.
> 
> ReST makes free with blank lines round blocks and list entries, and I agree
> this makes for inelegant source annotation. I tried to retain the wording
> unchanged and present the description as just "whitespace" changes to make a
> list in the formatted output - as close as I could to what the author
> appears to intend.
> 
> If you're OK with a mild rewrite of the return value description, e.g. as
> two sentences (On success: p; q. On failure: x; y; z.), then we can fix the
> doc build and have terser source comments and a happier kerneldoc.

I think it's more important that the documentation interferes to a
minimal degree with the code in the file, so please rewrite if it
improves it.  (btw, I'm the author.)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
