Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F435FDDD2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJMP7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJMP7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:59:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857B1119DE
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/WfJkKfjhP57r/b+C7iA38g5GgcTaYHWSUa7nCy32AY=; b=qZr2jByOfJJv12q6mcBMNrP3O6
        qw4jRwE/epvYbHjRY8m4lszYfZmiub3qjRRZz2LYfm6AhVtklHLkXliDgF2iM/wlAy669LAE80mG3
        r7ltB+9V58Y2AvkbufAIKn92NrQElp80zUEQaNc3nM+hx5U1saC+xEZfLsgH5CU/rveA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oj0bx-001txi-Ta; Thu, 13 Oct 2022 17:59:05 +0200
Date:   Thu, 13 Oct 2022 17:59:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: socket leaks observed in Linux kernel's passive close path
Message-ID: <Y0g1ye1ldw+c6Ile@lunn.ch>
References: <SJ0PR84MB1847204B80E86F8449DE1AAAB2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
 <Y0genWOLGfy2kQ/M@lunn.ch>
 <SJ0PR84MB184707E40732357494D0EC17B2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR84MB184707E40732357494D0EC17B2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 02:44:02PM +0000, Arankal, Nagaraj wrote:
> Hi Andrew,
> Thanks for looking into this,  I have not tested this on V6.0 kernel, and as far as I know I have not observed any fixes in this area, that's why I posted this, as this seems to be a valid case.

Please don't top post. And set your mailer to wrap lines at around 78
characters.

Please post your test results for v6.0. Just because you have not seen
any fixes in the last 4 years does not mean it has not been fixed.

    Andrew
