Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97662217342
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgGGQDk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jul 2020 12:03:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:33373 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgGGQDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 12:03:39 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6DD81CECEE;
        Tue,  7 Jul 2020 18:13:34 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 1/3] Bluetooth: Add new quirk for broken local ext
 features max_page
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200705195110.405139-2-anarsoul@gmail.com>
Date:   Tue, 7 Jul 2020 18:03:37 +0200
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DF6CC01A-0282-45E2-A437-2E3E58CC2883@holtmann.org>
References: <20200705195110.405139-1-anarsoul@gmail.com>
 <20200705195110.405139-2-anarsoul@gmail.com>
To:     Vasily Khoruzhick <anarsoul@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vasily,

> Some adapters (e.g. RTL8723CS) advertise that they have more than
> 2 pages for local ext features, but they don't support any features
> declared in these pages. RTL8723CS reports max_page = 2 and declares
> support for sync train and secure connection, but it responds with
> either garbage or with error in status on corresponding commands.

please send the btmon for this so I can see what the controller is responding.

Regards

Marcel

