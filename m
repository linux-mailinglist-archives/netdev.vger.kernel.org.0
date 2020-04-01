Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117D419A6B5
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 09:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbgDAH5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 03:57:13 -0400
Received: from a3.inai.de ([88.198.85.195]:38992 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732046AbgDAH5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 03:57:12 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id AEF815876E1B7; Wed,  1 Apr 2020 09:57:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id AE30160C62DC3;
        Wed,  1 Apr 2020 09:57:10 +0200 (CEST)
Date:   Wed, 1 Apr 2020 09:57:10 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
In-Reply-To: <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2004010955340.2411@n3.vanv.qr>
References: <20200331163559.132240-1-zenczykowski@gmail.com> <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr> <20200331181641.anvsbczqh6ymyrrl@salvia> <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 2020-03-31 23:21, Maciej Żenczykowski wrote:

>Right, this is not in 5.6 as it's only in net-next atm as it was only
>merged very recently.

Sorry. I read between the lines and had picked up "v0 is not present" 
and erroneously applied that statement to the standard kernel.
