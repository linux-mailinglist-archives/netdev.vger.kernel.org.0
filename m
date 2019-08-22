Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1FD98C2A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 09:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfHVHEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 03:04:00 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44920 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728497AbfHVHEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 03:04:00 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0h8Y-0001a5-Op; Thu, 22 Aug 2019 09:03:58 +0200
Date:   Thu, 22 Aug 2019 09:03:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paul Moore <paul@paul-moore.com>
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
Message-ID: <20190822070358.GE20113@breakpoint.cc>
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:
> Hello netdev,
> 
> I was just made aware of the skb extension work, and it looks very
> appealing from a LSM perspective.  As some of you probably remember,
> we (the LSM folks) have wanted a proper security blob in the skb for
> quite some time, but netdev has been resistant to this idea thus far.

Is that "blob" in addition to skb->secmark, or a replacement?
