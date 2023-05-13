Return-Path: <netdev+bounces-2372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9975F701915
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 20:17:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5D3E281835
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB3679D6;
	Sat, 13 May 2023 18:17:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F474C6B
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:17:54 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A2B199F
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 11:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=rF8Pj0AZVMpCF+xjpfTxA1W6UPUd3PtojuNsHpB2GSo=; b=v+QjVAmx43UQjVhxhHWXL1VZhA
	Ifhnvo2FcUZtnVImsNzo5vzMbl6Nh7RLf0tQff2WfxWLnoA93nwk35jUsawnqNVx7TI70LE4sS0o2
	cNSTXhwiA/lf/EHyGQW/wAzb9UZPZwgDe9YjiXQIv/uMAvr3US0gnU9eI6xjvJhGnvJ0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxtoQ-00ClaU-63; Sat, 13 May 2023 20:17:46 +0200
Date: Sat, 13 May 2023 20:17:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 7/9] net: pcs: xpcs: correct pause resolution
Message-ID: <422f5470-c827-4199-9f87-43120db78e0e@lunn.ch>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWYJ-002QsU-IT@rmk-PC.armlinux.org.uk>
 <f1b8d851-1e01-4719-aa2e-4b628838a515@lunn.ch>
 <ZF/TLuDSHDZmwonu@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF/TLuDSHDZmwonu@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Hi Russell
> > 
> > I must be missing something. Why not use phylink_resolve_an_pause()?
> 
> Check the next few patches... it eventually gets to using the c73
> helper, entirely eliminating this function.

Yes, i got to that eventually.

What might of helped would of been to include something like:

  This is a staged conversion, so that its easier to bisect down to
  the change that caused anye breakage. The aim is to replace this code
  with the c73 helper.

in the commit message. 

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

