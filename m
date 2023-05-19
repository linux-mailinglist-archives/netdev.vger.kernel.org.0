Return-Path: <netdev+bounces-3989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 420AE709F02
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 127141C21335
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B74012B85;
	Fri, 19 May 2023 18:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401D512B82
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 18:23:11 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B1E1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=p6eMyHl40A9wkS/MjAuqAE295bzfPP7wzjNQDjplvVg=; b=P29sJjNY4/xfDFo0ylTgw2x74l
	gae+uMVafOKesWgnHEriiMEb3iGnXMq9i1GOEvT+LX+f8pKSnwkbGJDi6shKqjo9vCUjLI9EEVU+I
	k/73BHQEYRKd3lQ9PTPoV4OIjEiWq4QTHb6hr65eR9r5DE4vGV0PSfXJdWs4J4pvqesg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q04kY-00DMBK-Md; Fri, 19 May 2023 20:22:46 +0200
Date: Fri, 19 May 2023 20:22:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	intel-wired-lan@lists.osuosl.org, shannon.nelson@amd.com,
	simon.horman@corigine.com, leon@kernel.org, decot@google.com,
	willemb@google.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org,
	"Singhai, Anjali" <anjali.singhai@intel.com>,
	"Orr, Michael" <michael.orr@intel.com>
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Message-ID: <52826c35-eba1-40fb-bfa9-23a87400bfa4@lunn.ch>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <20230519013710-mutt-send-email-mst@kernel.org>
 <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +config IDPF
> +	tristate "Intel(R) Infrastructure Data Path Function Support"
> +	depends on PCI_MSI
> +	select DIMLIB
> +	help
> +	  This driver supports Intel(R) Infrastructure Processing Unit (IPU)
> +	  devices.
> 
> It can be updated with Intel references removed when the spec becomes
> standard and meets the community requirements.

Is IPU Intels name for the hardware which implements DPF? I assume
when 'Intel' is dropped, IPU would also be dropped? Which leaves the
help empty.

And i assume when it is no longer tied to Intel, the Kconfig entry
will move somewhere else, because at the moment, it appears to appear
under Intel, when it probably should be at a higher level, maybe
'Network device support'? And will the code maybe move to net/idpf?

<tongue in cheek>
Maybe put it into driver/staging/idpf for the moment?
</tongue in cheek>

	 Andrew

