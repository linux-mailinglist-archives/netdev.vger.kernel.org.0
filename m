Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106CC1EF49B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgFEJt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 05:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgFEJt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 05:49:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9D8C08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 02:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jsZILS7s/QI6lfvYAG4qWMoUES37ftZyNlT7z9dOv5o=; b=KdqhcsBRf9dmj+s5G5hJUNhLA
        AGcxYfyMiEHyE/WH74rg5bYdytAv9L/GMcY1BST1D0cpB1YeCClQskCNlpdxehBR1FrQoI7U39443
        X/xseXa7unCrnH1yXFiVrMPKjhX+ZdZ9PICZMe4fnk2/DPKs1Va99mkf+RzBF2d9JtA2leyKgRZUD
        rWhLGu1cpPncHQ+lDv/P+XaJ9gfdLvnB4WNqOkO6719IA36EOkrgP07rQL/OJGoFzeD2pZ5O1e0CG
        H2/YQ/3ZvysL9kfrkga8cVAuJTUKxjgMDrZU6X7FcRZJRVHBXfWZP9iukjm1+91ihqlhJ9g/rCCGw
        POJCQSgwg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49640)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jh8yS-0001na-Ik; Fri, 05 Jun 2020 10:49:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jh8yM-0007MV-CG; Fri, 05 Jun 2020 10:49:10 +0100
Date:   Fri, 5 Jun 2020 10:49:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Message-ID: <20200605094910.GI1551@shell.armlinux.org.uk>
References: <3268996.Ej3Lftc7GC@tool>
 <20200521151916.GC677363@lunn.ch>
 <20200521152656.GU1551@shell.armlinux.org.uk>
 <CABwr4_vdWWRBMXeK9uGLnuK++9uuM_FBygypv_2PhCRnsOEcEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABwr4_vdWWRBMXeK9uGLnuK++9uuM_FBygypv_2PhCRnsOEcEA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 05:55:19PM +0200, Daniel González Cabanelas wrote:
> Thanks for the comments.
> 
> I'll look for a better approach.


Hi Daniel,

I've just pushed out phylink a patch adding this functionality. I'm
intending to submit it when net-next re-opens. See:

http://git.armlinux.org.uk/cgit/linux-arm.git/patch/?id=58c81223e17e39433895cfaf3dbf401134334779

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
