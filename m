Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AFA19386A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgCZGPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:15:13 -0400
Received: from ni.piap.pl ([195.187.100.5]:52966 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgCZGPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:15:13 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 02:15:12 EDT
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id D5531441EC3;
        Thu, 26 Mar 2020 07:08:35 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl D5531441EC3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1585202916; bh=clbKiLn6qUATsS6QO/fUtOXJXjf33KFTkCDMmyg02uo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iMNGF6WY331i4QFJdjveDasWP1Hd62KJpkcDJOlPrBkYPAQrC+vnXjbe133okFxbp
         H2MxtXbpUrITB5OuZLtd+QNjKlR+T9eiTVHH1zHbMoZeQEpHekNtG8lfmhicQaLYv3
         OK76HTmXZ7SePtnbguhSuGkUa0KEdFdUIxEno7E8=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kubakici@wp.pl>, khc@pm.waw.pl,
        davem@davemloft.net, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wan/hdlc_x25: make lapb params configurable
References: <20200113124551.2570-1-ms@dev.tdt.de>
        <20200113055316.4e811276@cakuba>
        <83f60f76a0cf602c73361ccdb34cc640@dev.tdt.de>
        <20200114045149.4e97f0ac@cakuba>
        <3b439730f93e29c9e823126b74c2fbd3@dev.tdt.de>
Date:   Thu, 26 Mar 2020 07:08:34 +0100
In-Reply-To: <3b439730f93e29c9e823126b74c2fbd3@dev.tdt.de> (Martin Schiller's
        message of "Tue, 14 Jan 2020 14:33:51 +0100")
Message-ID: <m3v9mr8x7h.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.721, not scanned, whitelist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I overlooked this mail, sorry.

Martin Schiller <ms@dev.tdt.de> writes:

> sethdlc validates the GENERIC_HDLC_VERSION at compile time.
>
> https://mirrors.edge.kernel.org/pub/linux/utils/net/hdlc/
>
> Another question:
> Where do I have to send my patch for sethdlc to?

I guess you have to put your own version somewhere. I don't have access
to hdlc directory at kernel.org anymore, this stuff (sync serial with
HDLC) is no longer in use around here.
--=20
Krzysztof Halasa

=C5=81UKASIEWICZ Research Network
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
