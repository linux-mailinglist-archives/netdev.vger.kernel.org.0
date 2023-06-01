Return-Path: <netdev+bounces-7044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BE771968A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AD412816B7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F00314261;
	Thu,  1 Jun 2023 09:14:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349FA13AFB
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E770C433D2;
	Thu,  1 Jun 2023 09:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685610842;
	bh=ysr19ykWuCDaS2xafT1YDerKvtGKlTxvqTLcdhIJ5PA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HDFLVauXWDELZgAWHW918L6ZBHpnxeRShvPkfGZLW/Pu3xelY/wvG/KwLdd2mIt5A
	 OzwdqiRiJrGXXwDCJ5wWydEsUla0AQn53w4boHt2Ublkqv98I8miaxcW8M9HFys+Q2
	 u8fVIFt+iyVeQYFaSy8ILsAwpkjeYGJFIMzrUi6A=
Date: Thu, 1 Jun 2023 10:14:00 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Panait, Dragos Marian" <dragos.panait@windriver.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	Ruihan Li <lrh2000@pku.edu.cn>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6.1 1/1] bluetooth: Add cmd validity checks at the start
 of hci_sock_ioctl()
Message-ID: <2023060116-brush-entail-0d8c@gregkh>
References: <20230530122629.231821-1-dragos.panait@windriver.com>
 <20230530122629.231821-2-dragos.panait@windriver.com>
 <2023053043-duo-collide-fd9c@gregkh>
 <PH0PR11MB495229C3DABA728EE5C8A19EFA489@PH0PR11MB4952.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495229C3DABA728EE5C8A19EFA489@PH0PR11MB4952.namprd11.prod.outlook.com>

On Wed, May 31, 2023 at 10:06:11AM +0000, Panait, Dragos Marian wrote:
> Done! (without the cover letter for newer kernels :))

All now queued up, thanks.

You could have just send a one sentance email saying "Please apply
commit XYZ to all stable kernels please" which would have been much
simpler and easier for you :)

thanks,

greg k-h

