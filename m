Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6D254F0E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 21:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgH0Tq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 15:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgH0Tq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 15:46:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7736422BEA;
        Thu, 27 Aug 2020 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598557587;
        bh=7F73r5xuZSXlQnnHYjMeJ3o4B0ESySBeTRkJiMtfmkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YAcc91HUodeaAzMbCf2elb1GePtY2HhRpdH8tD/FIPAoQ06ObP/5mGoNsnlUOSXtB
         7fDYmyn8aJaqPthUQ+DQy7GJMdciretelGjEKSHa6qk5wnjhDolc9J0Kobeye6ORwq
         rOFSVse7hGv0BsRGvWXJ3O/7x3w00OD7wcO096Xs=
Date:   Thu, 27 Aug 2020 12:46:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 07/12] ionic: reduce contiguous memory
 allocation requirement
Message-ID: <20200827124625.511ef647@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200827180735.38166-8-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
        <20200827180735.38166-8-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 11:07:30 -0700 Shannon Nelson wrote:
> +	q_base = (void *)PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);

The point of PTR_ALIGN is to make the casts unnecessary. Does it not
work?
