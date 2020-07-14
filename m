Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DA721E47B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgGNA0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:26:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33706 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbgGNA0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 20:26:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jv8lt-004xKH-E2; Tue, 14 Jul 2020 02:26:09 +0200
Date:   Tue, 14 Jul 2020 02:26:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200714002609.GB1140268@lunn.ch>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
 <20200713154118.3a1edd66@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713154118.3a1edd66@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jarod

Do you have this change scripted? Could you apply the script to v5.4
and then cherry-pick the 8 bonding fixes that exist in v5.4.51. How
many result in conflicts?

Could you do the same with v4.19...v4.19.132, which has 20 fixes.

This will give us an idea of the maintenance overhead such a change is
going to cause, and how good git is at figuring out this sort of
thing.

	Andrew
