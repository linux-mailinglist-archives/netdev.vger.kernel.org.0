Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522B4222082
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGPKU1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 06:20:27 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:52885 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgGPKU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 06:20:26 -0400
Received: from sogo3.sd4.0x35.net (sogo3.sd4.0x35.net [10.200.201.53])
        (Authenticated sender: pbl@bestov.io)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPA id 37508FF810;
        Thu, 16 Jul 2020 10:20:24 +0000 (UTC)
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
In-Reply-To: <CAD=hENefWXPsvPSLsnRyM5bbjYpYkfg2JMQegxia90P_JN7f5A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
Date:   Thu, 16 Jul 2020 12:20:24 +0200
Cc:     "netdev" <netdev@vger.kernel.org>
To:     "Zhu Yanjun" <zyjzyj2000@gmail.com>
MIME-Version: 1.0
Message-ID: <398-5f102a00-7b-4ccf8d80@121109257>
Subject: =?utf-8?q?Re=3A?= Bonding driver unexpected behaviour
User-Agent: SOGoMail 4.3.2
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Zhu Yanjun,

On Thursday, July 16, 2020 11:45 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote: 
 
> On Thu, Jul 16, 2020 at 4:08 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
> >
> > 
> >
> > On Thursday, July 16, 2020 09:45 CEST, Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > > You can use team to make tests.
> > I'm not sure I understand what you mean. Could you point me to relevant documentation?
> 
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec-comparison_of_network_teaming_to_bonding
> 
> Use team instead of bonding to make tests.
That seems like a Red Hat-specific feature. Unfortunately, I do not know Red Hat.
Nor I would have the possibility of using Red Hat in production even if I could get teaming to work instead of bonding.

Riccardo P. Bestetti

