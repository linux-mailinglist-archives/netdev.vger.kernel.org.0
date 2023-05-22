Return-Path: <netdev+bounces-4427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D5370CB51
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 903E0280FE6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E4B174CE;
	Mon, 22 May 2023 20:38:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F2A168CC
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:38:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32C110C3
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=OtpNzInUK52lCXIDnI0hK+1s/2t0Rhnt7Mx63GopKyg=; b=Z53zAno4kgEy87+NBjKaXfLg4I
	igQHJkCiQxmvpkFq09rOGw/D0bwMhQjBXDCwGNun5V6JgEddWkH+onvuHbCsdYz+SazwkaAq6nTm5
	u/g4hLJNc38vOdFc8QDHpqZARZXBRlK1IlYTBtktlCFZoCQlZ5u+Z78+PDVW/bAA6v9c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1CI2-00DaCJ-Ir; Mon, 22 May 2023 22:37:58 +0200
Date: Mon, 22 May 2023 22:37:58 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Singhai, Anjali" <anjali.singhai@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	"Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
	"Tantilov, Emil S" <emil.s.tantilov@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>,
	"leon@kernel.org" <leon@kernel.org>,
	"decot@google.com" <decot@google.com>,
	"willemb@google.com" <willemb@google.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Orr, Michael" <michael.orr@intel.com>
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Message-ID: <f5e32e43-1c7f-4d39-808d-ef882268d30e@lunn.ch>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <20230519013710-mutt-send-email-mst@kernel.org>
 <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
 <20230521051826-mutt-send-email-mst@kernel.org>
 <CO1PR11MB4993CB559E5BA413B66FF09493439@CO1PR11MB4993.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4993CB559E5BA413B66FF09493439@CO1PR11MB4993.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 08:08:47PM +0000, Singhai, Anjali wrote:
> I agree on Help message change as it is not accurate now and I like MST's suggestion. 
> 
Hi Anjali

Please don't top post.

Also, please trim your replies. All the standard network etiquette
things.

	Andrew

