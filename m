Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E21227B51
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 11:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgGUJAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 05:00:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:59248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgGUJAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 05:00:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7B63AF27;
        Tue, 21 Jul 2020 09:00:17 +0000 (UTC)
Message-ID: <1595322008.29149.5.camel@suse.de>
Subject: Re: [PATCH v5 net-next 2/5] net: cdc_ether: export
 usbnet_cdc_update_filter
From:   Oliver Neukum <oneukum@suse.de>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net,
        Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>
Date:   Tue, 21 Jul 2020 11:00:08 +0200
In-Reply-To: <20200715184100.109349-3-bjorn@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
         <20200715184100.109349-3-bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 15.07.2020, 20:40 +0200 schrieb Bjørn Mork:
> 
> @@ -90,6 +90,7 @@ static void usbnet_cdc_update_filter(struct usbnet *dev)
>  			USB_CTRL_SET_TIMEOUT
>  		);
>  }
> +EXPORT_SYMBOL_GPL(usbnet_cdc_update_filter);

Hi,

this function is pretty primitive. In fact it more or less
is a straight take from the spec. Can this justify the _GPL
version?

	Regards
		Oliver

