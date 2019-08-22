Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B119A0EF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388402AbfHVUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:15:24 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:49486 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730203AbfHVUPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:15:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0tUO-0006ir-Od; Thu, 22 Aug 2019 22:15:20 +0200
Date:   Thu, 22 Aug 2019 22:15:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
Message-ID: <20190822201520.GJ20113@breakpoint.cc>
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
 <20190822070358.GE20113@breakpoint.cc>
 <CAHC9VhQ_+3ywPu0QRzP3cSgPH2i9Br994wJttp-yXy2GA4FrNg@mail.gmail.com>
 <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:
> Given that the original objection to using a skb extension for a
> security blob was that an extension is dynamic, and that the ubiquitous
> nature of LSM use makes that unreasonable, it would seem that supporting
> the security blob as a basic part if the skb would be the obvious and
> correct solution. If the normal case is that there is an LSM that would
> befit from the native (unextended) support of a blob, it would seem
> that that is the case that should be optimized.

What is this "blob"? i.e., what would you like to add to sk_buff to make
whatever use cases you have in mind work?
