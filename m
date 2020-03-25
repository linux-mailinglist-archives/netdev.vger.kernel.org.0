Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4119245C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCYJlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:41:49 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:57163 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbgCYJlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:41:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 04BF7580340;
        Wed, 25 Mar 2020 05:41:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 25 Mar 2020 05:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Klx7cl
        Nx7M6l2BSBDUdgE1tqCDY0GLtMd/cbY5UaVAE=; b=khb3+M1C0fl1jFPTKU6FTu
        9JXVbLzOpHzfMqNCL7Kfyzet7M96K3ydLju7Dg6sBif+UkkR8xGqX67AviXAORwQ
        PhZqAhhSRmLlV8Abr+2c7bJN9iYlIl61tf+Q2/1yMS8EGapMzFHYj4mVv8Ua9f96
        g9WixZXDqK5N71K7lSKcF5tzM0YBrvAdhXSZ0B68czyEAqBMBLzm9Va6rspjXSzl
        5VxTI7HbUGPREl9w3RmfLRNj2ffXPe7fiXnapY3Lk+RkDhKmWS+MieYEeqoYrwpu
        GHUI4syFRQ2dDflWI/kwx/SufQMKuEgU7rXk7BBaOUrmNEE1/L3/PAzVJ0uhRFCA
        ==
X-ME-Sender: <xms:Wid7XofVBu2dl9Jdp5-hACjfdYtSoqw5_bHRZ7FWVfJEbx6jzNoGcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehfedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepjeelrd
    dukedtrdelgedrvddvheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Wid7Xm6A3gd0yTrA_tso_qPQomBMwvB_jd_Wn_lvpR-F2OIM5MfsAg>
    <xmx:Wid7XtZldYQ7RFjIdeqmxB8ZuQtrTAku0h1XjsHqwZ1PLjbm7kL3wA>
    <xmx:Wid7XoGTiPJUqaTUX6HZt7wQ1tuh0e44ev90O5BG0f23jN4cUjFO_g>
    <xmx:Wyd7XjjNyoP9KzUZnLnVkcohzwTvm3N3xKmcMQmbfarNB_2sIoOAtw>
Received: from localhost (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3711A3066163;
        Wed, 25 Mar 2020 05:41:46 -0400 (EDT)
Date:   Wed, 25 Mar 2020 11:41:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/15] devlink: Add packet trap policers support
Message-ID: <20200325094143.GA1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
 <20200324193250.1322038-2-idosch@idosch.org>
 <20200324203109.71e1efc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324203109.71e1efc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:31:09PM -0700, Jakub Kicinski wrote:
> On Tue, 24 Mar 2020 21:32:36 +0200 Ido Schimmel wrote:
> > +/**
> > + * devlink_trap_policers_register - Register packet trap policers with devlink.
> > + * @devlink: devlink.
> > + * @policers: Packet trap policers.
> > + * @policers_count: Count of provided packet trap policers.
> > + *
> > + * Return: Non-zero value on failure.
> > + */
> > +int
> > +devlink_trap_policers_register(struct devlink *devlink,
> > +			       const struct devlink_trap_policer *policers,
> > +			       size_t policers_count)
> > +{
> > +	int i, err;
> > +
> > +	mutex_lock(&devlink->lock);
> > +	for (i = 0; i < policers_count; i++) {
> > +		const struct devlink_trap_policer *policer = &policers[i];
> > +
> > +		if (WARN_ON(policer->id == 0)) {
> > +			err = -EINVAL;
> > +			goto err_trap_policer_verify;
> > +		}
> > +
> > +		err = devlink_trap_policer_register(devlink, policer);
> > +		if (err)
> > +			goto err_trap_policer_register;
> > +	}
> > +	mutex_unlock(&devlink->lock);
> > +
> > +	return 0;
> > +
> > +err_trap_policer_register:
> > +err_trap_policer_verify:
> 
> nit: as you probably know the label names are not really in compliance
> with:
> https://www.kernel.org/doc/html/latest/process/coding-style.html#centralized-exiting-of-functions
> ;)

Hi Jakub, thanks for the thorough review!

I assume you're referring to the fact that the label does not say what
the goto does? It seems that the coding style guide also allows for
labels that indicate why the label exists: "Choose label names which say
what the goto does or why the goto exists".

This is the form I'm used to, but I do adjust the names in code that
uses the other form (such as in netdevsim).

I already used this form in previous devlink submissions, so I would
like to stick to it unless you/Jiri have strong preference here.

> 
> > +	for (i--; i >= 0; i--)
> > +		devlink_trap_policer_unregister(devlink, &policers[i]);
> > +	mutex_unlock(&devlink->lock);
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
