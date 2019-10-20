Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11376DE052
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 22:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfJTUHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 16:07:36 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:53635 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfJTUHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 16:07:36 -0400
X-Originating-IP: 75.54.222.30
Received: from ovn.org (75-54-222-30.lightspeed.rdcyca.sbcglobal.net [75.54.222.30])
        (Authenticated sender: blp@ovn.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id D466440009;
        Sun, 20 Oct 2019 20:07:21 +0000 (UTC)
Date:   Sun, 20 Oct 2019 12:07:06 -0700
From:   Ben Pfaff <blp@ovn.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, pshelar@ovn.org,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [ovs-dev] [PATCH] Change in openvswitch kernel module to support
 MPLS label depth of 3 in ingress direction.
Message-ID: <20191020190706.GC25323@ovn.org>
References: <1571581532-18581-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571581532-18581-1-git-send-email-martinvarghesenokia@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 07:55:32PM +0530, Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The openvswitch kernel module was supporting a MPLS label depth of 1
> in the ingress direction though the userspace OVS supports a max depth
> of 3 labels. This change enables openvswitch module to support a max
> depth of 3 labels in the ingress.
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

Thanks for the patch!

Usually, for kernel module changes, the workflow is to submit the change
upstream to the Linux kernel first ("upstream first").  Then, afterward,
we backport the upstream changes into the OVS repository.

I see that you have CCed this to the Linux kernel networking list
(netdev) but the patch itself is against the OVS repo.  Probably, if you
want to get reviews from netdev, you should instead post a patch against
the net-next repository.

Thanks again for working to improve Open vSwitch.
