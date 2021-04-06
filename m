Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85710355526
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbhDFNa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:30:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232505AbhDFNa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 09:30:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTln4-00F7fU-Dy; Tue, 06 Apr 2021 15:30:46 +0200
Date:   Tue, 6 Apr 2021 15:30:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Rob Herring <robh@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: Document
 dsa,tag-protocol property
Message-ID: <YGxihuL2T12HKso1@lunn.ch>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-4-tobias@waldekranz.com>
 <20210327181343.GA339863@robh.at.kernel.org>
 <87blarloyi.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blarloyi.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, Vladimir: I will just list dsa and edsa for now. If it is needed
> on other devices, people can add them to the list after they have tested
> their drivers. Fair?

O.K.

	Andrew
