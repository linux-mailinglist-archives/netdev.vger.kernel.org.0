Return-Path: <netdev+bounces-11619-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7DD733B36
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 986DE2817CB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5F96AA7;
	Fri, 16 Jun 2023 20:55:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1EECB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:55:12 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3567E35B0;
	Fri, 16 Jun 2023 13:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=g3k6hqFaYIXi1uEg6ZWXJWwWnw9i4DBE8W22BOuxYzI=; b=Lpe7ElxmZgLLiAR+Fx9mIjWNWG
	SJ4eCjnNvP5CvJKWsmGn0qQPJggSqGa5GaGOTdmffcDSZGWbftgOfr0E1lZrioYlW3IGBrh/j/PRf
	LW/tAN/otyMYQ403IjFsRrJNLDFEHBj4NRHZW0+XLv1mgHEQFvIDORy1BNVJPzseIUhg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAGTG-00Gl7A-99; Fri, 16 Jun 2023 22:55:02 +0200
Date: Fri, 16 Jun 2023 22:55:02 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	richardcochran@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
Subject: Re: [PATCH net-next v1 10/14] net: phy: nxp-c45-tja11xx: handle FUSA
 irq
Message-ID: <2f4e3219-6c74-4ea7-bd4e-21f3ce23d8e4@lunn.ch>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-11-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-11-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +#define VEND1_ALWAYS_ACCESSIBLE		0x801F

Odd name. Is there a VEND1_NEVER_ACCESSIBLE?
VEND1_SOMETIMES_ACCESSIBLE?

	Andrew

