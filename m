Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D422AA23D
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 03:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgKGCoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 21:44:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728136AbgKGCod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 21:44:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1730920724;
        Sat,  7 Nov 2020 02:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604717073;
        bh=l7oVi3/9hWnqDjktwcHHGQwmn+hpdfTCKlBJdvSChDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vbWzxkGJU0HH5ywGanSYy+H7/Vmm96ghpifAbMgdzRJN35osqWecSZdg0OiJvFcE1
         pJSF+YU/sw97zG2Gk4nQD5p1YJOg6rVa/Ry2krElRtq1adTiu7soVXTzgaaEhIvPaC
         uxzgBKPbauTHy2bgIPlefrcYIX3B8JJnzNq/bcwg=
Date:   Fri, 6 Nov 2020 18:44:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/5] bonding: rename bond components
Message-ID: <20201106184432.07a6ab18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106200436.943795-1-jarod@redhat.com>
References: <20201106200436.943795-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 15:04:31 -0500 Jarod Wilson wrote:
> The bonding driver's use of master and slave, while largely understood
> in technical circles, poses a barrier for inclusion to some potential
> members of the development and user community, due to the historical
> context of masters and slaves, particularly in the United States. This
> is a first full pass at replacing those phrases with more socially
> inclusive ones, opting for bond to replace master and port to
> replace slave, which is congruent with the bridge and team drivers.

If we decide to go ahead with this, we should probably also use it as
an opportunity to clean up the more egregious checkpatch warnings, WDYT?

Plan minimum - don't add new ones ;)
