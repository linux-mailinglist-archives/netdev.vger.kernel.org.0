Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEA32CA4AE
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391273AbgLAN7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:59:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388079AbgLAN7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 08:59:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kk6Ag-009hEx-LW; Tue, 01 Dec 2020 14:58:22 +0100
Date:   Tue, 1 Dec 2020 14:58:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Vollmer <peter.vollmer@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20201201135822.GB2290587@lunn.ch>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930191956.GV3996795@lunn.ch>
 <20201001062107.GA2592@fido.de.innominate.com>
 <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
 <87y2in94o7.fsf@waldekranz.com>
 <20201126222359.GO2075216@lunn.ch>
 <20201201090041.GB6059@unassigned-hostname.unassigned-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201090041.GB6059@unassigned-hostname.unassigned-domain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter

> Maybe I can get some information from our support if
> DSA_TAG_PROTO_EDSA is supported for the port config (0x4) register
> on the 6341 switch after all or if it should be omitted.

It would be nice to hear what Marvell says about this. It does seem an
odd thing to remove, so it could be a documentation issue.

    Andrew
