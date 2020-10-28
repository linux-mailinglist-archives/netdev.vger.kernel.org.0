Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19F429DBC4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbgJ2ANi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50764 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390810AbgJ2ANf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZuz-003u9E-72; Wed, 28 Oct 2020 02:06:25 +0100
Date:   Wed, 28 Oct 2020 02:06:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH net-next] net: ceph: Fix most of the kerneldoc warings
Message-ID: <20201028010625.GB930647@lunn.ch>
References: <20201028005907.930575-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028005907.930575-1-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the subject suggests, there is still one warning left:

net/ceph/crush/mapper.c:674: warning: Function parameter or member 'left' not described in 'crush_choose_indep'

It would be nice if somebody who understands this code could fix that
warning. Then ceph become W=1 clean.

	 Andrew
