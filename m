Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99318277745
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIXQ4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXQ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:56:37 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B62C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 09:56:37 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id E51CB58743C10; Thu, 24 Sep 2020 18:56:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id E0CD560E2A003;
        Thu, 24 Sep 2020 18:56:33 +0200 (CEST)
Date:   Thu, 24 Sep 2020 18:56:33 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] build: avoid make jobserver warnings
In-Reply-To: <20200924091107.1f11508c@hermes.lan>
Message-ID: <nycvar.YFH.7.78.908.2009241854160.8326@n3.vanv.qr>
References: <20200921232231.11543-1-jengelh@inai.de> <20200921171907.23d18b15@hermes.lan> <nycvar.YFH.7.78.908.2009220812330.10964@n3.vanv.qr> <20200924091107.1f11508c@hermes.lan>
User-Agent: Alpine 2.23 (LSU 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thursday 2020-09-24 18:11, Stephen Hemminger wrote:
>> >
>> >MFLAGS is a way to pass flags from original make into the sub-make.  
>> 
>> MAKEFLAGS and MFLAGS are already exported by make (${MAKE} is magic
>> methinks), so they need no explicit passing. You can check this by
>> adding something like 'echo ${MAKEFLAGS}' to the lib/Makefile
>> libnetlink.a target and then invoking e.g. `make -r` from the
>> toplevel, and notice how -r shows up again in the submake.
>
>With your change does the options through the same?

Well yes.
