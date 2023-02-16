Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40BB698EF3
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBPIrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBPIrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:47:24 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3569738676
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:47:23 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2693B240008;
        Thu, 16 Feb 2023 08:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676537241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdU4aSChp1TIV6z35feEVLbjz/X/DoPoNoL4sF4WkLo=;
        b=E9ASiUgNISOwPajmj3LeJm1L3K7PaoOi9t1ehYg0q+BUdKx03izqmGG6oZ8C5n69KKeYBy
        o1+Ksthqe9XMW6dUNFqaWml8iH2cuHSTRiZTutR/+v5dGY4XlK34VtIAGhcbLbkvXb0OQj
        Qd4w1Rs8vxaHnbo1GpPT2tK4x2AZvrmaJi4XE1PsFQgDouOoCPXlJoIKyVNk9bzSTlZ+N3
        LMXk4Oi1h5fOBRxg6Ocoy8vAatWItLlIRkpSsCHF+RGUgr8I537m46L0j9m8rhcuymXVfY
        +yetP6Hqe7461jex8KO0rBKdT06H4Be5x22fseAsF39+HkBDb9P2wL9QhHK0MQ==
Date:   Thu, 16 Feb 2023 09:47:18 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: net: phy: broadcom: error in rxtstamp callback?
Message-ID: <20230216094718.63b3244a@kmaincent-XPS-13-7390>
In-Reply-To: <B04768ED-4E00-46AD-87A0-8AF89479A87F@flugsvamp.com>
References: <20230215110755.33bb9436@kmaincent-XPS-13-7390>
        <B04768ED-4E00-46AD-87A0-8AF89479A87F@flugsvamp.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jonathan,

On Wed, 15 Feb 2023 11:39:02 -0800
Jonathan Lemon <jlemon@flugsvamp.com> wrote:

> The code is correct - see Documentation/networking/timestamping.rst
> 
> The function returns true/false to indicate whether a deferral is needed
> in order to receive the timestamp.  For this chip, a deferral is never
> required - the timestamp is inline if it is present.

Alright, thanks for your reply.

Regards,
