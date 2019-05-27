Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6892ACAE
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 02:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfE0Af6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 20:35:58 -0400
Received: from ozlabs.org ([203.11.71.1]:35153 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfE0Af6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 20:35:58 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Bygv6cqnz9s55; Mon, 27 May 2019 10:35:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558917355; bh=KdpjiN01GyCrcCD6rD0+jm4pBhoYGx0uPgLmLGkkUIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CnlxJNk/Zj/JsDkEtO7IDbHmxuW+cd4700mLvr5eJWbiTn38Mhx7P1RSaqtirubFg
         Lg8YeJateQV6AdZJMNrmBLrlXtBwR+6I9xotMds0Ryyo0yLgdH02DhTuNeGjrkS+XQ
         ODn4Ra6hprn3jUrTmdjmxcoVjIQwa+X0xSoscyiPKdBFrgIwBlVvnUqJVzASCZ47ZT
         0/flqQlwHBNDny1/ElxnwrNVFjP+OK1oc/KEyn+K05u7vrHPDvr5bWUwyy26PgeWSe
         Yhk6uPal5B7f+WL6FIfeZ7f/b6IPiYF87pap2yT9DEKzFOg5pM481Uq81VrgxL/zIi
         jyTOCEfKYCiiA==
Date:   Mon, 27 May 2019 10:35:53 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: [PATCH pppd v4] pppoe: custom host-uniq tag
Message-ID: <20190527003553.GA3380@blackberry>
References: <20190504164853.4736-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504164853.4736-1-mcroce@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 04, 2019 at 06:48:53PM +0200, Matteo Croce wrote:
> Add pppoe 'host-uniq' option to set an arbitrary
> host-uniq tag instead of the pppd pid.
> Some ISPs use such tag to authenticate the CPE,
> so it must be set to a proper value to connect.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Jo-Philipp Wich <jo@mein.io>

Thanks, patch applied.

Paul.
