Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E12DA8BE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgLOHop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgLOHoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 02:44:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05DCC06179C;
        Mon, 14 Dec 2020 23:43:44 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id q16so19899550edv.10;
        Mon, 14 Dec 2020 23:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g3JmsH/2qcpjo+dzXWng/ltGOYbO/xhpCV/mKd1Yxf0=;
        b=a2quU6gT64yfFa9CqXZdksQXMRT3X/QnPpR69onuCAqxBwpGCtd4GRzigoi875ZUd3
         4qanV6sEqQAXIjwkS4vwNj2tSnu5oHWmvqxRBvF42QRTDTd/PC1yhTcxveOSh+52LCg9
         jV2EKeoCq43AO0xHoa47G0nHzEIqITvj9LzeQm40a3Fys4JV6NRSvBkDbK0+n2liYo7G
         Uq9VHw+VhUNqVmNG62cKCQa5ogOe3DqADC6PmfsrizKkmvgSaqs8xFOVc4Uqa1cpsw8V
         XFAo+9Gwt3uaErk51uVNOnPbO0Ilfptxv491fuNRS5dgEv3/IsjW+gDgDCzzSavVYITw
         GnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g3JmsH/2qcpjo+dzXWng/ltGOYbO/xhpCV/mKd1Yxf0=;
        b=Dktb2iMWqcVKCTbO8GEdb4zMN/Lgh36QpwzXoVr4Oa83nSxGrTeSAx6awPoxP0J28Q
         WyZNVQG8QDSnRqvQSDHSubQyhCLNxeKjAunjCJYZTnabXfP0paHsP4vrgrPNlanoM4/Z
         Wb8+KH2jgz6utwDqx2WHc5S9rJco+jQbKyy9DOhBPykOk7m3Ixj86uxKnjin9xRomX07
         42oodC0Ww/Iw1fmQeFXbJD6p/0EBk6D9LyE+FWoR/yyPqXAdL7nF4erxBJQXaS6AjmvC
         1fOKKlMzFyXAOJ7gG1yoRI3kmbGVJE4Mw6SfQS12qsjdo2ZAMDSxcPNP1pIv59d93l2L
         AcpA==
X-Gm-Message-State: AOAM533JkBmfAi+37qtKx+SXz3GhchAo5g2bp6cH7mV6b/BYH6syhH+C
        MITgL0apE9LnCGU0mORLuCA=
X-Google-Smtp-Source: ABdhPJy/tA+9R9VDicIsZcx83X7KG9maJCZUYQN6UlUqUVVFixqf1ckLPCvNIyjweWM7lsuhXYy7tg==
X-Received: by 2002:a50:d604:: with SMTP id x4mr1216081edi.64.1608018223475;
        Mon, 14 Dec 2020 23:43:43 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id de12sm17587998edb.82.2020.12.14.23.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 23:43:42 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 15 Dec 2020 09:43:41 +0200
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20201215074341.czqxowvs4ztjo4k6@skbuf>
References: <20201126174057.0ac8d95b@canb.auug.org.au>
 <20201215070125.5f982171@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215070125.5f982171@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:01:25AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 26 Nov 2020 17:40:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the net-next tree, today's linux-next build (htmldocs)
> > produced this warning:
> > 
> > include/linux/phy.h:869: warning: Function parameter or member 'config_intr' not described in 'phy_driver'
> > 
> > Introduced by commit
> > 
> >   6527b938426f ("net: phy: remove the .did_interrupt() and .ack_interrupt() callback")
> 
> I am still getting this warning.

Hi,

Sorry for not responding in time, I know I verified this the first time
but somehow did not answer the email.

The .config_intr() is documented but it seems that it's not parsed
properly since the comment starts on the same line as the /**. A diff
like below seems to do the trick. I will send it out.

--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -743,7 +743,8 @@ struct phy_driver {
 	/** @read_status: Determines the negotiated speed and duplex */
 	int (*read_status)(struct phy_device *phydev);
 
-	/** @config_intr: Enables or disables interrupts.
+	/**
+	 * @config_intr: Enables or disables interrupts.
 	 * It should also clear any pending interrupts prior to enabling the
 	 * IRQs and after disabling them.
 	 */

Ioana

