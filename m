Return-Path: <netdev+bounces-4340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D42770C224
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61A311C20B34
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C356F14A95;
	Mon, 22 May 2023 15:17:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70FA14A8E
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:17:24 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663CDCD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=p+X/MUEz+DPTRG5AEQ8jZxfVPBSZ2Jpt2/nncOuuGpU=; b=EBo16rw1T58iHotyGnDUqVY/us
	6x2vNcTbLmE3n+3GcleLBI70Ns8NCAIQ92cNbptClxjxQyEyoAxYCVqjwDze3BK1f8q9zCvEi6BBk
	9Y0SiSw3cqj2OAq7R/wFSq1lhraeELKSTg5aEQqwGky//l54q89Ivr0DWWJHHMoywr1jFBkNXqP+T
	/laAJ/yQCtdNM3B6fUmt0rn5u3AqfRHK7GagjcbmaGajHQReIE7ewFebo1sMJjiElsVM4Xn1TZ/AE
	xkPsRnHTUPWFeyk83rur3KULm/gUtnOlK23RqY1ctSfexGOrdG9rZ0sDq3ovwuniayypQir6j9ZBb
	nHGAxntA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45102)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q17Hi-000720-9T; Mon, 22 May 2023 16:17:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q17Hg-00082w-B5; Mon, 22 May 2023 16:17:16 +0100
Date: Mon, 22 May 2023 16:17:16 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Josua Mayer <josua@solid-run.com>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 1/1] net: sfp: add support for HXSX-ATRI-1 copper SFP+
 module
Message-ID: <ZGuHfK/FDf07sSwz@shell.armlinux.org.uk>
References: <20230522145242.30192-1-josua@solid-run.com>
 <20230522145242.30192-2-josua@solid-run.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522145242.30192-2-josua@solid-run.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 05:52:42PM +0300, Josua Mayer wrote:
> Walsun offers commercial ("C") and industrial ("I") variants of
> multi-rate copper SFP+ modules.
> 
> Add quirk for HXSX-ATRI-1 using same parameters as the already supported
> commercial variant HXSX-ATRC-1.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Please note that this depends on this patch:
"net: sfp: add support for a couple of copper multi-rate modules"
https://patchwork.kernel.org/project/netdevbpf/patch/E1q0JfS-006Dqc-8t@rmk-PC.armlinux.org.uk/

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

