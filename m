Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DCD2A34F3
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgKBUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:12:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgKBULf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 15:11:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZgAu-004rzh-OM; Mon, 02 Nov 2020 21:11:32 +0100
Date:   Mon, 2 Nov 2020 21:11:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeffrey Layton <jlayton@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH net-next] net: ceph: Fix most of the kerneldoc warings
Message-ID: <20201102201132.GJ1042051@lunn.ch>
References: <20201028005907.930575-1-andrew@lunn.ch>
 <20201102192920.GA923955@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102192920.GA923955@tleilax.poochiereds.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 02:55:03PM -0500, Jeffrey Layton wrote:
> On Wed, Oct 28, 2020 at 01:59:07AM +0100, Andrew Lunn wrote:
> > net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oid' not described in 'ceph_cls_break_lock'
> > net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oloc' not described in 'ceph_cls_break_lock'
> > net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'osdc' not described in 'ceph_cls_break_lock'
> > net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'oid' not described in 'ceph_cls_lock'
> > net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'oloc' not described in 'ceph_cls_lock'
> > net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'osdc' not described in 'ceph_cls_lock'
> > net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'oid' not described in 'ceph_cls_unlock'
> > net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'oloc' not described in 'ceph_cls_unlock'
> > net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'osdc' not described in 'ceph_cls_unlock'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or member 'choose_args' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or member 'weight_max' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or member 'weight' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:466: warning: Function parameter or member 'work' not described in 'crush_choose_firstn'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'bucket' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'choose_args' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'map' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'numrep' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'out2' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'out' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'outpos' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'parent_r' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'recurse_to_leaf' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'recurse_tries' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'tries' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'type' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'weight_max' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'weight' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'work' not described in 'crush_choose_indep'
> > net/ceph/crush/mapper.c:655: warning: Function parameter or member 'x' not described in 'crush_choose_indep'
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  net/ceph/cls_lock_client.c | 12 +++++++++---
> >  net/ceph/crush/mapper.c    | 21 ++++++++++++++++++++-
> >  2 files changed, 29 insertions(+), 4 deletions(-)
> > 
> 
> If you resend, please do cc ceph-devel.

Hi Jeffrey

Thanks for the comments. I will rework my patch and resend.

       Andrew
