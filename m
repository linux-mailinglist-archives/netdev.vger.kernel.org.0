Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48F273121
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgIURsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbgIURsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 13:48:33 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A1B921D91;
        Mon, 21 Sep 2020 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600710513;
        bh=/6lVCApzy/QRAD3/Ybe/SBVz422zdZyEwg23y8iKv4w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lya51utlxI/DenLJcvdlNwsKPlUVRDheIHK9JgnWfP3NsS/5Rta4mEv+m8il+/TPO
         QPlb8JAqFgpZoSTjOiNnYtZQd8CChnQfUd2buNPfYNUYH6FojG7kTul89zdHHJU8oe
         w0vG583zOa2u+pDYEWPrvtTHagLPvEOe/1I5En8Q=
Message-ID: <2d321585b8bc625980f1f798ffe0c106301ec7cd.camel@kernel.org>
Subject: Re: [pull request][net 00/15] mlx5 Fixes 2020-09-18
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Date:   Mon, 21 Sep 2020 10:48:31 -0700
In-Reply-To: <20200919.165027.155707282988829868.davem@davemloft.net>
References: <20200918172839.310037-1-saeed@kernel.org>
         <20200919.165027.155707282988829868.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-09-19 at 16:50 -0700, David Miller wrote:
> From: saeed@kernel.org
> Date: Fri, 18 Sep 2020 10:28:24 -0700
> 
> >  ('net/mlx5e: Protect encap route dev from concurrent release')
> 
> I'm being asked to queue this up for -stable, but this change does
> not
> exist in this pull request.
> 
> Please sort this out and resubmit.

Sorry about this, i dropped this patch and forgot to remove this line
from the cover-letter's -stable request..

You can apply this series as is.

Thanks,
Saeed.

