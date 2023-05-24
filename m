Return-Path: <netdev+bounces-5150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED50470FD13
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFBE21C20C17
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C80B1F194;
	Wed, 24 May 2023 17:46:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419E41F190
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:46:34 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF4B10CE;
	Wed, 24 May 2023 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=yuz9ArgDnVPACpReUH5oMEZEfxp4zwXrDfDOiInJOvE=; b=0ksWKqNVVSgcxoh2U44il/trCt
	jmk6AHgcrdLOrK+dYNpyEIqE8tRTs28bRPkWvBehWzMcb9B+vKLBU02WPBJI8sfw3RVLz+Oq7keNx
	U021KRyN3qSHlAuLNACj1il1xhFRVioQfEtXLQpKckcyWMQXhXKErcaAvOBdv2FesIQ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1sYY-00Dotu-Cw; Wed, 24 May 2023 19:45:50 +0200
Date: Wed, 24 May 2023 19:45:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Fabio Estevam <festevam@gmail.com>
Cc: stable <stable@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <eec26f5c-1ad7-48ff-94a9-708a0a9f3b02@lunn.ch>
References: <CAOMZO5Dd7z+k0X1aOug1K61FMC56u2qG-0s4vPpaMjT-gGVqaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Dd7z+k0X1aOug1K61FMC56u2qG-0s4vPpaMjT-gGVqaA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:38:22PM -0300, Fabio Estevam wrote:
> Hi,
> 
> I would like to request the commit below to be applied to the 6.1-stable tree:
> 
> 91e87045a5ef ("net: dsa: mv88e6xxx: Add RGMII delay to 88E6320")
> 
> Without this commit, there is a failure to retrieve an IP address via DHCP.

Please could your provide a Fixes: tag.

       Andrew

