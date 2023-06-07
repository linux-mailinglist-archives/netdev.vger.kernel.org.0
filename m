Return-Path: <netdev+bounces-8734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 137CF7256A4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B08D8281246
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052FE6FDF;
	Wed,  7 Jun 2023 07:58:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECF91C3A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:58:55 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E948E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=g4RsH+TnlUn+XqVbLIv0nYx2xbvGawDAn/PdTMQ7OMY=; b=uf/GNldXmRbPxT930wCGJ/j6Eq
	VF/AE5U/1bnOY4ZlMEoy/ukVVqm3WthHEkCycD5tVkWqTkyOeQYa7L0y3iRT4TTNVqEKyylA2ODfn
	MQSTNEDyMI+hnyEmuGS59x6M4XE6YT+Pp8lxZ9ANaQx26yGsTZEgaC2cB86y1Gy9r5VBetLYuQrdk
	iqKZioyDhC0iXIDzyWwfQ8gtj3au9TREKerHMaPWOkn2upj6Qxo8KAnK8KWHMEnacmkzZADu1JW9C
	v99q7XbZurZOtf5sUDRAkoT1vfvqgfcO4mZLCkJ7VW9w1OfRxhjfyxz3Y6JKUKEmfzu5JO2aMvcah
	hvJOoE/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54514)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6o44-00071V-Mb; Wed, 07 Jun 2023 08:58:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6o40-00081z-Lu; Wed, 07 Jun 2023 08:58:40 +0100
Date: Wed, 7 Jun 2023 08:58:40 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Madalin Bucur <madalin.bucur@nxp.com>,
	Madalin Bucur <madalin.bucur@oss.nxp.com>, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Michal Kubiak <michal.kubiak@intel.com>, kernel@pengutronix.de,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/8] net: dpaa: Improve error reporting
Message-ID: <ZIA4sMTPCE13F6AY@shell.armlinux.org.uk>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-2-u.kleine-koenig@pengutronix.de>
 <ZH9m4wFPTWsXXBAD@boxer>
 <20230607064235.5uylgrxef574eitw@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230607064235.5uylgrxef574eitw@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:42:35AM +0200, Uwe Kleine-König wrote:
> On Tue, Jun 06, 2023 at 07:03:31PM +0200, Maciej Fijalkowski wrote:
> > On Tue, Jun 06, 2023 at 06:28:22PM +0200, Uwe Kleine-König wrote:
> > > Instead of the generic error message emitted by the driver core when a
> > > remove callback returns an error code ("remove callback returned a
> > > non-zero value. This will be ignored."), emit a message describing the
> > > actual problem and return zero to suppress the generic message.
> > > 
> > > Note that apart from suppressing the generic error message there are no
> > > side effects by changing the return value to zero. This prepares
> > > changing the remove callback to return void.
> > > 
> > > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > index 431f8917dc39..6226c03cfca0 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > @@ -3516,6 +3516,8 @@ static int dpaa_remove(struct platform_device *pdev)
> > >  	phylink_destroy(priv->mac_dev->phylink);
> > >  
> > >  	err = dpaa_fq_free(dev, &priv->dpaa_fq_list);
> > > +	if (err)
> > > +		dev_err(dev, "Failed to free FQs on remove\n");
> > 
> > so 'err' is now redundant - if you don't have any value in printing this
> > out then you could remove this variable altogether.
> 
> Good hint, err can have different values here (at least -EINVAL and
> -EBUSY), so printing it has some values. I'll wait a bit for more
> feedback to this series and then prepare a v3 with
> 
> 	dev_err(dev, "Failed to free FQs on remove (%pE)\n", err);

							     ERR_PTR(err)

%p formats always take a pointer.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

