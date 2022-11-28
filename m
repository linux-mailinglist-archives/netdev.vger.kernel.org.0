Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DBE63A9D4
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiK1Nn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiK1NnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:43:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF1910F5;
        Mon, 28 Nov 2022 05:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FqplfntYOXRB9uazZ3RPNVd421+dqloQ48E/sL2sfao=; b=Sojc2MyLV+YY5TwKiK/M1LkWS1
        bPf37p5bYIa1hubz9h72zjssOinUmjSORvhZoCl6VI4Eb1CLv/wFY6V0L+UjW3PHSU9dSzsYAGo4s
        Z8kUya/+A3TLw/ontSVRGopiWnKV+9GggH+VLhGC/xtUBG4ff3fnNlyLGRKZgE0tjpZo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozePZ-003enb-9D; Mon, 28 Nov 2022 14:43:05 +0100
Date:   Mon, 28 Nov 2022 14:43:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
Message-ID: <Y4S66dJjgpIrmylO@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4JJ8Dyz7urLz/IM@lunn.ch>
 <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
 <Y4N9IAlQVsdyIJ9Q@lunn.ch>
 <CAMZ6RqJHFyeG0ZMaAAfJ_30t-oucJVm05Et-H9DEgzbWj-K6vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJHFyeG0ZMaAAfJ_30t-oucJVm05Et-H9DEgzbWj-K6vA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> That said, I think I answered all your comments. Can I get your
> reviewed-by or ack tag? Thank you!

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
