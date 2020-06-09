Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8119F1F4691
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 20:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388445AbgFISrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 14:47:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49906 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728400AbgFISrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 14:47:06 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F10CD600AC;
        Tue,  9 Jun 2020 18:47:03 +0000 (UTC)
Received: from us4-mdac16-37.ut7.mdlocal (unknown [10.7.66.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EEA9F8009E;
        Tue,  9 Jun 2020 18:47:03 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5E5AA80055;
        Tue,  9 Jun 2020 18:47:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0597C70006C;
        Tue,  9 Jun 2020 18:47:01 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Jun 2020
 19:46:50 +0100
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>
CC:     <o.rempel@pengutronix.de>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <corbet@lwn.net>, <mkubecek@suse.cz>, <linville@tuxdriver.com>,
        <david@protonic.nl>, <kernel@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mkl@pengutronix.de>, <marex@denx.de>,
        <christian.herber@nxp.com>, <amitc@mellanox.com>,
        <petrm@mellanox.com>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
 <20200607153019.3c8d6650@hermes.lan>
 <20200607.164532.964293508393444353.davem@davemloft.net>
 <20200609101935.5716b3bd@hermes.lan>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <b72ca873-d2d1-7361-c7b1-95156cc6b20f@solarflare.com>
Date:   Tue, 9 Jun 2020 19:46:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200609101935.5716b3bd@hermes.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25470.003
X-TM-AS-Result: No-2.044500-8.000000-10
X-TMASE-MatchedRID: I31hiQfYWUPoJ7/BCqClnedNi+0D4LmKiqCjW9swDxLk1kyQDpEj8Cj5
        3aEB5qDLm+1fvYNhFyBXxguJUe2GCZRvsQ56OO4qOctXWsNe0qUOb7iOh4v5/Ul/J9Ro+MABiZT
        IEGltZs0aSRZgvGgsvMSl+MnAnGpqvRY9Eui9+hzGAzTlP3eD9uq6JaIt1QeiAOoJD+M7nOm+O/
        Fr84/iGLBUm9aP+NTyDXaTDtw9qt5JH11OOVB0ycEvKlG0CjjIojQrbrPpzzpMat91z9vy7D1Hu
        bz0trKxNKNt3Qs1qr4Z6AKZ5CDJjoKuaJr4qkjK7I0RzvPYnMLEMDPEVkc5zDrW2rRfTfGrOcWn
        tyTplLMC9V8w+aDVpAEhGMDW4utRwttG2hjGkeWieObBHrVnUgAWEaci2Ej6abJxhiIFjJlsKYH
        pCFiCVDRpr9frjETDuFcRhUATSXhCUInNiru3wMqquP3qhQpqprzcyrz2L11xps32fZo2QXTYjQ
        YTwAbR8sfxw8KspferIfOiZKnM2A6sbMpeuGpS+eKrHwoGV9MXyU2Cxtlxb2OMyb1Ixq8Vy46qz
        TSht7d0QOrJWPXvVus4dFY9QFMbycoUIDNWKI3Rc75iroKqAmFDbD27a+U2Vu51yUEi8EMqO2wf
        skV8/JS3tfb2kgp1ToE+2PHM5kemrRd7k2N7HK4GXSu53BPrGnGYpZN+xAgiOHkao5dpqAneP6Z
        J8eSdj3aMjC9UtrzPNTb4wusNVDVM51zwCh5jMKPrF7dK57N9LQinZ4QefL6qvLNjDYTwmTDwp0
        zM3zoqtq5d3cxkNTizVX2KWmj74ZLrXlvDZfHYjHL5MME3WgOM+WwfFTZmNLfMQ9dk3GCpalTRT
        gI0TqRpZ1FQ4dmEsVnyzyXEOWtA2U6LQNPaf9oQy0xZsLaTBsRAh8WmTAcG2WAWHb2qekrMHC7k
        mmSWJy4DmWREnADvdCUIFuasqw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.044500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25470.003
X-MDID: 1591728423-ZrdNJEdlB61c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disclaimer: *definitely* not speaking for my employer.

On 09/06/2020 18:19, Stephen Hemminger wrote:
> How many times have you or Linus argued about variable naming.
> Yes, words do matter and convey a lot of implied connotation and meaning.
Connotation, unlike denotation, is widely variable.  I would aver
 that for most people who are triggered or offended by the technical
 use of master/slave or similar terms, this is a *learned behaviour*
 that occurs because they have been taught that they should be
 offended by these words.  Are these people also incapable of using
 those words to describe actual historical slavery?
There is a difference between stating "X relates to Y as a slave to
 a master" and "You relate to me (or ought to do so) as a slave to a
 master".  The former is a merely factual claim which is often true
 of technical entities (and in the past or in certain parts of the
 world today is true of some humans, however morally wrong); the
 latter is an assertion of power.  It is only the latter which is,
 or at any rate should be, offensive; the attempt to ban the former
 rests on an equivocation between positive and normative uses.
Anyone who can't put connotation aside and stick to denotation
 (a) needs to grow up
 (b) is ill-suited to working with computers.

> Most projects and standards bodies are taking a stance on fixing the
> language. The IETF is has proposed making changes as well.
An expired Internet-Draft authored by a human-rights charity and a
 media studies postgrad student does not constitute "the IETF has
 proposed".  (Besides, it's historically inaccurate; it claims that
 the word "robot" means slave, when in fact it means the labour owed
 by a _serf_ ("robotnik").  And it cites Orwell with apparently *no*
 sense of irony whatsoever... he was arguing _against_ Newspeak, not
 for it!)

> A common example is that master/slave is unclear and would be clearer
> as primary/secondary or active/backup or controller/worker.
So why isn't controller/worker just as offensive, given all those
 labourers throughout history who have suffered under abusive
 managers?  Or does a word need a tenuous connection to race before
 it can be ritually purified from the language?
And is there really an EE anywhere who finds the terminology of
 master and slave clocks unclear?  I suspect very few would gain a
 better understanding from any of your suggested alternatives.

> Most of networking is based on standards. When the standards wording changes
> (and it will happen soon); then Linux should also change the wording in the
> source, api and documentation.
Rather, it seems that this is an attempt to change Linux in order
 to _de facto_ change the standard, thereby creating pressure on
 standards bodies to change it _de jure_ to match.  Yet, in the
 real world, engineers use and understand the current terminology;
 the push for language purification bears but little reference to
 anything outside of itself.

In conclusion, I'd like to quote from Henry Spencer's Ten
 Commandments for C Programmers (Annotated Edition) [1]:
> As a lamentable side issue, there has been some unrest from the
> fanatics of the Pronoun Gestapo over the use of the word "man"
> in [the eighth] Commandment, for they believe that great efforts
> and loud shouting devoted to the ritual purification of the
> language will somehow redound to the benefit of the downtrodden
> (whose real and grievous woes tendeth to get lost amidst all that
> thunder and fury).

Grumpily yours,
-ed

[1] https://www.lysator.liu.se/c/ten-commandments.html
